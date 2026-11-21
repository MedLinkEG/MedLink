
import { createServer, Model, Response } from "miragejs";

export function makeServer() {
  const otpCodes = new Map();
  const verifiedEmails = new Set();
  const tokens = new Map();

  let tokenCounter = 1;

  return createServer({
    models: {
      users: Model,
    },

    seeds(server) {
      server.create("user", {
        email: "patient@test.com",
        password: "123456",
        name: "Test Patient",
        role: "patient",
      });

      server.create("user", {
        email: "pharmacy@test.com",
        password: "123456",
        name: "Test Pharmacy",
        role: "pharmacy",
        pharmacyName: "MedLink Pharmacy",
        address: "Cairo, Egypt",
      });
    },

    routes() {
      this.namespace = "api";
      this.logging = true;

      // 1. Send OTP
      this.post("/auth/send-otp", (schema, request) => {
        const { email } = JSON.parse(request.requestBody);
        const normalizedEmail = email.toLowerCase().trim();

        const existingUser = schema.users.findBy({
          email: normalizedEmail,
        });

        if (existingUser) {
          return new Response(
            409,
            {},
            { error: "Email is already registered" }
          );
        }

        // Mock OTP: always 123456
        otpCodes.set(normalizedEmail, "123456");

        return {
          message: "OTP sent successfully",
        };
      });

      // 2. Verify OTP
      this.post("/auth/verify-otp", (schema, request) => {
        const { email, otp } = JSON.parse(request.requestBody);
        const normalizedEmail = email.toLowerCase().trim();

        const storedCode = otpCodes.get(normalizedEmail);

        if (!storedCode || storedCode !== otp) {
          return new Response(
            400,
            {},
            { error: "Invalid or expired OTP" }
          );
        }

        otpCodes.delete(normalizedEmail);
        verifiedEmails.add(normalizedEmail);

        return {
          message: "Email verified successfully",
          verified: true,
        };
      });

      // 3. Register
      this.post("/auth/register", (schema, request) => {
        const data = JSON.parse(request.requestBody);
        const email = data.email.toLowerCase().trim();

        if (!verifiedEmails.has(email)) {
          return new Response(
            403,
            {},
            { error: "Email verification required" }
          );
        }

        if (schema.users.findBy({ email })) {
          return new Response(
            409,
            {},
            { error: "Email already registered" }
          );
        }

        if (!["patient", "pharmacy"].includes(data.role)) {
          return new Response(
            400,
            {},
            { error: "Invalid account type" }
          );
        }

        const user = schema.users.create({
          email,
          password: data.password,
          name: data.name,
          role: data.role,
          pharmacyName: data.pharmacyName || null,
          address: data.address || null,
        });

        verifiedEmails.delete(email);

        return {
          message: "Account created successfully",
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
          },
        };
      });

      // 4. Login
      this.post("/auth/login", (schema, request) => {
        const { email, password } = JSON.parse(request.requestBody);

        const user = schema.users.findBy({
          email: email.toLowerCase().trim(),
        });

        if (!user || user.password !== password) {
          return new Response(
            401,
            {},
            { error: "Invalid email or password" }
          );
        }

        const accessToken = `mock-token-${tokenCounter++}`;

        tokens.set(accessToken, user.id);

        return {
          accessToken,
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
          },
        };
      });

      // 5. Get current authenticated user
      this.get("/auth/me", (schema, request) => {
        const authorization =
          request.requestHeaders.Authorization ||
          request.requestHeaders.authorization;

        const token = authorization?.replace("Bearer ", "");
        const userId = tokens.get(token);

        if (!userId) {
          return new Response(
            401,
            {},
            { error: "Unauthorized" }
          );
        }

        const user = schema.users.find(userId);

        return {
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
          },
        };
      });

      // 6. Logout
      this.post("/auth/logout", (schema, request) => {
        const authorization =
          request.requestHeaders.Authorization ||
          request.requestHeaders.authorization;

        const token = authorization?.replace("Bearer ", "");

        tokens.delete(token);

        return {
          message: "Logged out successfully",
        };
      });
    },
  });
}
