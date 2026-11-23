package com.example.coreapi.auth.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Email;

public record OtpRequest(

        @NotBlank(message = "Email is required")
        @Email(message = "Invalid email format")
        String email

) {}
