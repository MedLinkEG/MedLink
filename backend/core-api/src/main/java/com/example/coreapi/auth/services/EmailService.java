
package com.example.coreapi.auth.services;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${app.mail.from}")
    private String from;

    @Value("${app.mail.sender-name:MedLink}")
    private String senderName;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendRegistrationOtp(String email, String otp) {
        sendOtpEmail(
                email,
                "Verify your MedLink email",
                "Welcome to MedLink! Use this code to verify your email address."
                , otp);
    }

    public void sendPasswordResetOtp(String email, String otp) {
        sendOtpEmail(
                email,
                "Reset your MedLink password",
                "We received a request to reset your MedLink password."
                , otp);
    }

    private void sendOtpEmail(
            String email,
            String subject,
            String message
            , String otp) {

        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();

            MimeMessageHelper helper = new MimeMessageHelper(
                    mimeMessage,
                    true,
                    StandardCharsets.UTF_8.name()
            );

            helper.setFrom(from, senderName);
            helper.setTo(email);
            helper.setSubject(subject);

            String html = """
                    <!DOCTYPE html>
                    <html>
                    <body style="font-family: Arial, sans-serif;
                                 background-color: #f4f4f4;
                                 padding: 30px;">

                        <div style="max-width: 500px; margin: auto;
                                    background: white; padding: 30px;
                                    border-radius: 10px;">

                            <h2 style="color: #2563eb;">
                                MedLink
                            </h2>

                            <p>%s</p>

                            <div style="background: #f1f5f9;
                                        padding: 20px;
                                        text-align: center;
                                        border-radius: 8px;
                                        margin: 25px 0;">

                                <h1 style="letter-spacing: 8px;
                                           color: #2563eb;">
                                    %s
                                </h1>

                            </div>

                            <p>This code expires in 5 minutes.</p>

                            <p style="color: #777; font-size: 12px;">
                                If you did not request this code,
                                you can safely ignore this email.
                            </p>

                        </div>
                    </body>
                    </html>
                    """.formatted(message, otp);

            String plainText = message
                    + "\nYour verification code is: " + otp
                    + "\nThis code expires in 5 minutes.";

            helper.setText(plainText, html);

            mailSender.send(mimeMessage);

        } catch (MessagingException e) {
            throw new IllegalStateException(
                    "Failed to construct OTP email", e
            );
        } catch (Exception e) {
            throw new IllegalStateException(
                    "Failed to send OTP email", e
            );
        }
    }
}
