package com.example.coreapi.auth;


import com.example.coreapi.auth.dto.*;
import com.example.coreapi.auth.services.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(
            @Valid @RequestBody RegisterRequest request) {

        AuthResponse response = authService.register(request);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
    }

    @PostMapping("/register/request-otp")
    public ResponseEntity<Void> sendOTP(
            @Valid @RequestBody OtpRequest request) {

        authService.requestRegistrationOtp(request);

        return ResponseEntity.accepted().build();
    }

    @PostMapping("/register/verify-otp")
    public ResponseEntity<RegistrationOtpVerifiedResponse> verifyOTP(
            @Valid @RequestBody OtpVerify request) {

        RegistrationOtpVerifiedResponse response =
                authService.verifyRegistrationOtp(request);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(
            @Valid @RequestBody LoginRequest request) {

        AuthResponse response = authService.login(request);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<MessageResponse> forgotPassword(
            @Valid @RequestBody OtpRequest request) {

        MessageResponse response =
                authService.forgotPassword(request);

        return ResponseEntity.accepted().body(response);
    }

    @PostMapping("/forgot-password/verify-otp")
    public ResponseEntity<PasswordResetVerifiedResponse> verifyResetOtp(
            @Valid @RequestBody OtpVerify request) {

        PasswordResetVerifiedResponse response =
                authService.verifyPasswordResetOtp(request);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/reset-password")
    public ResponseEntity<Void> resetPassword(
            @Valid @RequestBody ResetPasswordRequest request) {

        authService.resetPassword(request);

        return ResponseEntity.noContent().build();
    }
}
