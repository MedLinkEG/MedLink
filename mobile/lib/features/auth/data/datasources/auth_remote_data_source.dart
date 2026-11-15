import 'package:dio/dio.dart';
import 'package:medlink/core/error/dio_error_mapper.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/features/auth/data/models/auth_response_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

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
