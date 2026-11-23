abstract final class ApiConstants {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const defaultTokenType = 'Bearer';

  static const login = '/api/auth/login';
  static const register = '/api/auth/register';
  static const forgotPassword = '/api/auth/forgot-password';
  static const verifyResetCode = '/api/auth/forgot-password/verify-otp';
  static const resetPassword = '/api/auth/reset-password';

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);

  static const statusBadRequest = 400;
  static const statusUnauthorized = 401;
  static const statusConflict = 409;
  static const statusServerError = 500;
}
