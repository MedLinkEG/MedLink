package com.example.coreapi.auth.otp;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import jakarta.persistence.LockModeType;

import java.util.Optional;
import java.util.UUID;

public interface OtpChallengeRepository
        extends JpaRepository<OtpChallenge, UUID> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""
        SELECT o FROM OtpChallenge o
        WHERE o.email = :email
        AND o.purpose = :purpose
    """)
    Optional<OtpChallenge> findForUpdate(
            @Param("email") String email,
            @Param("purpose") OtpPurpose purpose
    );

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""
        SELECT o FROM OtpChallenge o
        WHERE o.verificationTokenHash = :tokenHash
        AND o.purpose = :purpose
    """)
    Optional<OtpChallenge> findByTokenForUpdate(
            @Param("tokenHash") String tokenHash,
            @Param("purpose") OtpPurpose purpose
    );
}