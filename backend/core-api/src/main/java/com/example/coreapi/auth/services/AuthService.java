
package com.example.coreapi.auth.services;

import com.example.coreapi.auth.dto.*;
import com.example.coreapi.auth.exception.EmailAlreadyExistsException;
import com.example.coreapi.auth.otp.OtpService;
import com.example.coreapi.security.CustomUserDetails;
import com.example.coreapi.security.CustomUserDetailsService;
import com.example.coreapi.security.JwtService;
import com.example.coreapi.user.User;
import com.example.coreapi.user.UserRepository;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.Locale;
import java.util.UUID;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final CustomUserDetailsService userDetailsService;
    private final AuthenticationManager authenticationManager;
    private final OtpService otpService;

    public AuthService(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService,
            CustomUserDetailsService userDetailsService,
            AuthenticationManager authenticationManager,
            OtpService otpService1) {

        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.userDetailsService = userDetailsService;
        this.authenticationManager = authenticationManager;
        this.otpService = otpService1;
    }

    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {

        // Normalize email
        String email = request.email()
                .trim()
                .toLowerCase(Locale.ROOT);

        try {

            // Authenticate user credentials
            var authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            email,
                            request.password()
                    )
            );

            // Get authenticated user
            CustomUserDetails userDetails =
                    (CustomUserDetails) authentication.getPrincipal();

            // Generate JWT
            String token = jwtService.generateToken(userDetails);

            return new AuthResponse(token, "Bearer");

        } catch (AuthenticationException exception) {

            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED,
                    "Invalid email or password"
            );
        }
    }

    @Transactional
    public AuthResponse register(RegisterRequest request) {

        // Normalize email
        String email = request.email()
                .trim()
                .toLowerCase(Locale.ROOT);

        // Check email uniqueness
        if (userRepository.existsByEmailIgnoreCase(email)) {
            throw new EmailAlreadyExistsException();
        }

        // Create user entity
        User user = new User();

        user.setId(UUID.randomUUID());
        user.setFullName(request.fullName().trim());
        user.setEmail(email);
        user.setPasswordHash(
                passwordEncoder.encode(request.password())
        );

        // Set server-controlled defaults
        user.setRole("buyer");
        user.setIsActive(true);
        user.setCreatedAt(OffsetDateTime.now(ZoneOffset.UTC));

        // Optional phone
        String phone = request.phone();

        user.setPhone(
                phone == null || phone.isBlank()
                        ? null
                        : phone.trim()
        );

        // Save and flush to detect database uniqueness conflicts
        User savedUser;

        try {
            savedUser = userRepository.saveAndFlush(user);
        } catch (DataIntegrityViolationException exception) {
            if (isUniqueConstraintViolation(exception)) {
                throw new EmailAlreadyExistsException();
            }
            throw exception;
        }

        // Load the newly created user as Spring Security UserDetails
        CustomUserDetails userDetails =
                userDetailsService.loadUserById(savedUser.getId());

        // Generate JWT
        String token = jwtService.generateToken(userDetails);

        return new AuthResponse(token, "Bearer");
    }

    private boolean isUniqueConstraintViolation(Throwable exception) {

        Throwable current = exception;

        while (current != null) {

            if (current instanceof SQLException sqlException
                    && "23505".equals(sqlException.getSQLState())) {
                return true;
            }

            current = current.getCause();
        }

        return false;
    }

    public void requestRegistrationOtp(OtpRequest request) {

        String email = request.email()
                .trim()
                .toLowerCase(Locale.ROOT);

        if (userRepository.existsByEmailIgnoreCase(email)) {
            throw new EmailAlreadyExistsException();
        }

        otpService.sendRegistrationOtp(email);
    }

    public RegistrationOtpVerifiedResponse verifyRegistrationOtp(
            OtpVerify request) {

        String email = request.email()
                .trim()
                .toLowerCase(Locale.ROOT);

        String token = otpService.verifyRegistrationOtp(
                email,
                request.otp()
        ).orElseThrow(() -> new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Invalid or expired OTP"
        ));

        return new RegistrationOtpVerifiedResponse(token);
    }

    public MessageResponse forgotPassword(
            OtpRequest request) {

        String email = request.email()
                .trim()
                .toLowerCase(Locale.ROOT);

        if (userRepository.existsByEmailIgnoreCase(email)) {

            try {
                otpService.sendPasswordResetOtp(email);

            } catch (ResponseStatusException exception) {

                // Don't reveal whether an email exists
                // when the resend cooldown is active.
                if (exception.getStatusCode().value() != 429) {
                    throw exception;
                }
            }
        }

        return new MessageResponse(
                "If an account exists with this email, a password reset code has been sent."
        );
    }

    public PasswordResetVerifiedResponse verifyPasswordResetOtp(
            OtpVerify request) {

        String email = request.email()
                .trim()
                .toLowerCase(Locale.ROOT);

        String token = otpService.verifyPasswordResetOtp(
                email,
                request.otp()
        ).orElseThrow(() -> new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Invalid or expired OTP"
        ));

        return new PasswordResetVerifiedResponse(token);
    }

    @Transactional
    public void resetPassword(ResetPasswordRequest request) {

        String email = otpService
                .consumePasswordResetToken(request.resetToken())
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "Invalid, expired or already used reset token"
                ));

        User user = userRepository.findByEmailIgnoreCase(email)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Account not found"
                ));

        user.setPasswordHash(
                passwordEncoder.encode(request.newPassword())
        );

        userRepository.save(user);
    }
}
