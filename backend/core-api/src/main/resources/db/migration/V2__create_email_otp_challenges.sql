CREATE TABLE email_otp_challenges (
                                      id UUID PRIMARY KEY,
                                      email VARCHAR(320) NOT NULL,
                                      purpose VARCHAR(30) NOT NULL,
                                      otp_hash VARCHAR(64) NOT NULL,

                                      attempts INTEGER NOT NULL DEFAULT 0,

                                      sent_at TIMESTAMPTZ NOT NULL,
                                      expires_at TIMESTAMPTZ NOT NULL,

                                      verified_at TIMESTAMPTZ,
                                      verification_token_hash VARCHAR(64),
                                      verification_token_expires_at TIMESTAMPTZ,

                                      consumed_at TIMESTAMPTZ,

                                      CONSTRAINT uq_email_otp_purpose
                                          UNIQUE (email, purpose),

                                      CONSTRAINT chk_email_otp_attempts
                                          CHECK (attempts BETWEEN 0 AND 5)
);

CREATE UNIQUE INDEX uq_email_otp_verification_token
    ON email_otp_challenges (verification_token_hash)
    WHERE verification_token_hash IS NOT NULL;