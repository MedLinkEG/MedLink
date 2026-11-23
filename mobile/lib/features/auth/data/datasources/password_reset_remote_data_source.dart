import 'package:dio/dio.dart';
import 'package:medlink/core/error/dio_error_mapper.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/network/api_constants.dart';

class PasswordResetRemoteDataSource {
  const PasswordResetRemoteDataSource(this._dio);

  final Dio _dio;

  Future<void> requestReset(String email) => _send(
    () => _dio.post<void>(ApiConstants.forgotPassword, data: {'email': email}),
  );

  Future<String> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.verifyResetCode,
        data: {'email': email, 'otp': code},
      );
      final token = response.data?['resetToken'];
      if (token is! String || token.isEmpty) throw const UnknownFailure();
      return token;
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  /// Saves the new password. The backend answers 204 with no body.
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) => _send(
    () => _dio.post<void>(
      ApiConstants.resetPassword,
      data: {'resetToken': resetToken, 'newPassword': newPassword},
    ),
  );

  Future<void> _send(Future<Response<void>> Function() request) async {
    try {
      await request();
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
