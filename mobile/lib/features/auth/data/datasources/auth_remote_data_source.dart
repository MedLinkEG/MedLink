import 'package:dio/dio.dart';
import 'package:medlink/core/error/dio_error_mapper.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/network/api_constants.dart';
import 'package:medlink/features/auth/data/models/auth_response_model.dart';
import 'package:medlink/features/auth/domain/entities/log_in_data.dart';
import 'package:medlink/features/auth/domain/entities/register_data.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthResponseModel> logIn(LogInData data) => postForSession(
    ApiConstants.login,
    {'email': data.email, 'password': data.password},
  );

  Future<AuthResponseModel> register(RegisterData data) => postForSession(
    ApiConstants.register,
    {
      'fullName': data.fullName,
      'email': data.email,
      'phone': data.phone,
      'password': data.password,
    },
  );

  Future<AuthResponseModel> postForSession(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      final json = response.data;
      if (json == null) throw const UnknownFailure();
      return AuthResponseModel.fromJson(json);
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
