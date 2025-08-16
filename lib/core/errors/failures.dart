abstract class Failure implements Exception {
  final String message;
  const Failure(this.message);
  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

class ApiFailure extends Failure {
  final int? statusCode;
  const ApiFailure(super.message, {this.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
