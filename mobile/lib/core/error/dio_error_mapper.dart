import 'package:dio/dio.dart';
import 'package:medlink/core/error/failures.dart';
import 'package:medlink/core/network/api_constants.dart';

Failure mapDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badCertificate:
    case DioExceptionType.badResponse:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      break;
  }

  final status = error.response?.statusCode;
  if (status == ApiConstants.statusBadRequest) {
    return const InvalidDataFailure();
  }
  if (status == ApiConstants.statusUnauthorized) {
    return const UnauthorizedFailure();
  }
  if (status == ApiConstants.statusConflict) {
    return const ConflictFailure();
  }
  if (status != null && status >= ApiConstants.statusServerError) {
    return const ServerFailure();
  }
  return const UnknownFailure();
}
