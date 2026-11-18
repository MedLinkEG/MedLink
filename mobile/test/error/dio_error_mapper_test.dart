import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/core/error/dio_error_mapper.dart';
import 'package:medlink/core/error/failures.dart';

DioException errorWithStatus(int status) {
  final request = RequestOptions(path: '/test');
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response<void>(requestOptions: request, statusCode: status),
  );
}

void main() {
  test('no connection becomes NetworkFailure', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.connectionError,
    );
    expect(mapDioError(error), isA<NetworkFailure>());
  });

  test('a timeout becomes NetworkFailure', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.receiveTimeout,
    );
    expect(mapDioError(error), isA<NetworkFailure>());
  });

  test('400 becomes InvalidDataFailure', () {
    expect(mapDioError(errorWithStatus(400)), isA<InvalidDataFailure>());
  });

  test('401 becomes UnauthorizedFailure', () {
    expect(mapDioError(errorWithStatus(401)), isA<UnauthorizedFailure>());
  });

  test('409 becomes ConflictFailure', () {
    expect(mapDioError(errorWithStatus(409)), isA<ConflictFailure>());
  });

  test('500 and above become ServerFailure', () {
    expect(mapDioError(errorWithStatus(500)), isA<ServerFailure>());
    expect(mapDioError(errorWithStatus(503)), isA<ServerFailure>());
  });

  test('anything else becomes UnknownFailure', () {
    expect(mapDioError(errorWithStatus(418)), isA<UnknownFailure>());
  });
}
