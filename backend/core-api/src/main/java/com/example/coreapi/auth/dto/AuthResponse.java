
package com.example.coreapi.auth.dto;

public record AuthResponse(
        String accessToken,
        String tokenType
) {}
