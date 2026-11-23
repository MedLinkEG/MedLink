package com.example.coreapi.auth.otp;

import com.example.coreapi.auth.services.EmailService;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.Base64;
import java.util.HexFormat;
import java.util.Locale;
import java.util.Optional;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

@Service
public class OtpService {

    private final OtpChallengeRepository repository;
    private final EmailService emailService;
    private final String hmacSecret;

    private static final SecureRandom RANDOM = new SecureRandom();

    public OtpService(
            OtpChallengeRepository repository,
            EmailService emailService,
            @Value("${app.otp.hmac-secret}") String hmacSecret) {

        this.repository = repository;
        this.emailService = emailService;
        this.hmacSecret = hmacSecret;

        if (hmacSecret == null ||
                hmacSecret.getBytes(StandardCharsets.UTF_8).length < 32) {
            throw new IllegalStateException(
                    "OTP HMAC secret must contain at least 32 bytes"
            );
        }
    }

    // REGISTRATION
    @Transactional
    public void sendRegistrationOtp(String email) {
        sendOtp(email, OtpPurpose.REGISTRATION);
    }

    @Transactional
    public Optional<String> verifyRegistrationOtp(
            String email,
            String otp) {

        return verifyOtp(email, otp, OtpPurpose.REGISTRATION);
    }

    @Transactional
    public Optional<String> consumeRegistrationToken(String token) {
        return consumeToken(token, OtpPurpose.REGISTRATION);
    }

    // PASSWORD RESET
    @Transactional
    public void sendPasswordResetOtp(String email) {
        sendOtp(email, OtpPurpose.PASSWORD_RESET);
    }

    @Transactional
    public Optional<String> verifyPasswordResetOtp(
            String email,
            String otp) {

        return verifyOtp(email, otp, OtpPurpose.PASSWORD_RESET);
    }

    @Transactional
    public Optional<String> consumePasswordResetToken(String token) {
        return consumeToken(token, OtpPurpose.PASSWORD_RESET);
    }

    // SEND OTP

    private void sendOtp(String rawEmail, OtpPurpose purpose) {

        String email = normalizeEmail(rawEmail);

        OffsetDateTime now = now();

        OtpChallenge challenge = repository
                .findForUpdate(email, purpose)
                .orElse(null);

        // Enforce 60-second resend cooldown.
        if (challenge != null &&
                challenge.getSentAt().plusSeconds(60).isAfter(now)) {

            throw new ResponseStatusException(
                    HttpStatus.TOO_MANY_REQUESTS,
                    "Please wait before requesting another OTP"
            );
        }

        String otp = generateOtp();
        String hash = hashOtp(email, purpose, otp);

        if (challenge == null) {

            challenge = new OtpChallenge(
                    email,
                    purpose,
                    hash,
                    now,
                    now.plusMinutes(5)
            );

        } else {

            challenge.replaceOtp(
                    hash,
                    now,
                    now.plusMinutes(5)
            );
        }

        repository.save(challenge);

        // Send the email.
        if (purpose == OtpPurpose.REGISTRATION) {
            emailService.sendRegistrationOtp(email, otp);
        } else {
            emailService.sendPasswordResetOtp(email, otp);
        }
    }

    // VERIFY OTP

    private Optional<String> verifyOtp(
            String rawEmail,
            String otp,
            OtpPurpose purpose) {

        String email = normalizeEmail(rawEmail);

        if (otp == null || !otp.matches("\\d{6}")) {
            return Optional.empty();
        }

        OffsetDateTime now = now();

        OtpChallenge challenge = repository
                .findForUpdate(email, purpose)
                .orElse(null);

        if (challenge == null ||
                challenge.getExpiresAt().isBefore(now) ||
                challenge.getAttempts() >= 5 ||
                challenge.getVerifiedAt() != null ||
                challenge.getConsumedAt() != null) {

            return Optional.empty();
        }

        String submittedHash = hashOtp(email, purpose, otp);

        boolean matches = MessageDigest.isEqual(
                submittedHash.getBytes(StandardCharsets.US_ASCII),
                challenge.getOtpHash().getBytes(StandardCharsets.US_ASCII)
        );

        if (!matches) {

            challenge.recordFailedAttempt(now);
            repository.save(challenge);

            // Return normally so the failed attempt is committed.
            return Optional.empty();
        }

        // OTP is correct. Generate a temporary verification token.
        String token = generateToken();

        challenge.markVerified(
                hashToken(token),
                now,
                now.plusMinutes(10)
        );

        repository.save(challenge);

        return Optional.of(token);
    }

    // CONSUME VERIFICATION TOKEN

    private Optional<String> consumeToken(
            String token,
            OtpPurpose purpose) {

        if (token == null || token.isBlank()) {
            return Optional.empty();
        }

        String tokenHash = hashToken(token);

        OtpChallenge challenge = repository
                .findByTokenForUpdate(tokenHash, purpose)
                .orElse(null);

        OffsetDateTime now = now();

        if (challenge == null ||
                challenge.getVerifiedAt() == null ||
                challenge.getConsumedAt() != null ||
                challenge.getVerificationTokenExpiresAt() == null ||
                !challenge.getVerificationTokenExpiresAt().isAfter(now)) {

            return Optional.empty();
        }

        challenge.markConsumed(now);
        repository.save(challenge);

        return Optional.of(challenge.getEmail());
    }

    // GENERATION

    private String generateOtp() {

        return String.format(
                Locale.ROOT,
                "%06d",
                RANDOM.nextInt(1_000_000)
        );
    }

    private String generateToken() {

        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);

        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(bytes);
    }

    // HASHING

    private String hashOtp(
            String email,
            OtpPurpose purpose,
            String otp) {

        return hmac(
                purpose.name() + ":" + email + ":" + otp
        );
    }

    private String hmac(String value) {

        try {

            Mac mac = Mac.getInstance("HmacSHA256");

            mac.init(new SecretKeySpec(
                    hmacSecret.getBytes(StandardCharsets.UTF_8),
                    "HmacSHA256"
            ));

            return HexFormat.of().formatHex(
                    mac.doFinal(
                            value.getBytes(StandardCharsets.UTF_8)
                    )
            );

        } catch (Exception exception) {

            throw new IllegalStateException(
                    "Failed to hash OTP",
                    exception
            );
        }
    }

    private String hashToken(String token) {

        try {

            MessageDigest digest =
                    MessageDigest.getInstance("SHA-256");

            return HexFormat.of().formatHex(
                    digest.digest(
                            token.getBytes(StandardCharsets.UTF_8)
                    )
            );

        } catch (Exception exception) {

            throw new IllegalStateException(
                    "Failed to hash verification token",
                    exception
            );
        }
    }

    // HELPERS

    private String normalizeEmail(String email) {

        if (email == null || email.isBlank()) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Email is required"
            );
        }

        return email.trim().toLowerCase(Locale.ROOT);
    }

    private OffsetDateTime now() {
        return OffsetDateTime.now(ZoneOffset.UTC);
    }
}