sealed class Failure implements Exception {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class InvalidDataFailure extends Failure {
  const InvalidDataFailure();
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

final class ConflictFailure extends Failure {
  const ConflictFailure();
}

final class ServerFailure extends Failure {
  const ServerFailure();
}

final class UnknownFailure extends Failure {
  const UnknownFailure();
}
