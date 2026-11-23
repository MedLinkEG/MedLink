package com.example.coreapi.auth.dto;

public record PasswordResetVerifiedResponse(
        String resetToken
) {}