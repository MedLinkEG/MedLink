package com.example.coreapi.user;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.OffsetDateTime;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "users")
public class User {
    @Id
    @ColumnDefault("gen_random_uuid()")
    @Column(name = "id", nullable = false)
    private UUID id;

    @Size(max = 320)
    @NotNull
    @Column(name = "email", nullable = false, length = 320)
    private String email;

    @NotNull
    @Column(name = "password_hash", nullable = false, length = Integer.MAX_VALUE)
    private String passwordHash;

    @Size(max = 200)
    @NotNull
    @Column(name = "full_name", nullable = false, length = 200)
    private String fullName;

    @Size(max = 30)
    @Column(name = "phone", length = 30)
    private String phone;

    @Size(max = 20)
    @NotNull
    @ColumnDefault("'buyer'")
    @Column(name = "role", nullable = false, length = 20)
    private String role;

    @NotNull
    @ColumnDefault("true")
    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    @NotNull
    @ColumnDefault("now()")
    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;


}