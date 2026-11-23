package com.example.coreapi.auth.otp;

import jakarta.persistence.*;

import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "email_otp_challenges")
public class OtpChallenge {

    @Id
    private UUID id;

    @Column(nullable = false, length = 320)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private OtpPurpose purpose;

    @Column(name = "otp_hash", nullable = false, length = 64)
    private String otpHash;

    private int attempts;

    @Column(name = "sent_at", nullable = false)
    private OffsetDateTime sentAt;

    @Column(name = "expires_at", nullable = false)
    private OffsetDateTime expiresAt;

    @Column(name = "verified_at")
    private OffsetDateTime verifiedAt;

    @Column(name = "verification_token_hash", length = 64)
    private String verificationTokenHash;

    @Column(name = "verification_token_expires_at")
    private OffsetDateTime verificationTokenExpiresAt;

    @Column(name = "consumed_at")
    private OffsetDateTime consumedAt;

    protected OtpChallenge() {}

    public OtpChallenge(
            String email,
            OtpPurpose purpose,
            String otpHash,
            OffsetDateTime now,
            OffsetDateTime expiresAt) {

        this.id = UUID.randomUUID();
        this.email = email;
        this.purpose = purpose;
        this.otpHash = otpHash;
        this.sentAt = now;
        this.expiresAt = expiresAt;
        this.attempts = 0;
    }

    public void replaceOtp(
            String otpHash,
            OffsetDateTime now,
            OffsetDateTime expiresAt) {

        this.otpHash = otpHash;
        this.sentAt = now;
        this.expiresAt = expiresAt;
        this.attempts = 0;

        this.verifiedAt = null;
        this.verificationTokenHash = null;
        this.verificationTokenExpiresAt = null;
        this.consumedAt = null;
    }

    public void recordFailedAttempt(OffsetDateTime now) {
        attempts++;

        if (attempts >= 5) {
            expiresAt = now;
        }
    }

    public void markVerified(
            String tokenHash,
            OffsetDateTime now,
            OffsetDateTime tokenExpiresAt) {

        this.verifiedAt = now;
        this.verificationTokenHash = tokenHash;
        this.verificationTokenExpiresAt = tokenExpiresAt;
    }

    public void markConsumed(OffsetDateTime now) {
        this.consumedAt = now;
    }

    public String getEmail() {
        return email;
    }

    public String getOtpHash() {
        return otpHash;
    }

    public int getAttempts() {
        return attempts;
    }

    public OffsetDateTime getSentAt() {
        return sentAt;
    }

    public OffsetDateTime getExpiresAt() {
        return expiresAt;
    }

    public OffsetDateTime getVerifiedAt() {
        return verifiedAt;
    }

    public String getVerificationTokenExpiresAtPlaceholder() {
        return null;
    }

    public String getVerificationTokenHash() {
        return verificationTokenHash;
    }

    public OffsetDateTime getVerificationTokenExpiresAt() {
        return verificationTokenExpiresAt;
    }

    public OffsetDateTime getConsumedAt() {
        return consumedAt;
    }
}