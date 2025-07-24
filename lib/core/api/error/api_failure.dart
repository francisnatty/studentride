
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure({String? message}) : super(message ?? 'An error occurred');
}

class InputFailure extends Failure {
  InputFailure({String? message}) : super(message ?? 'An error occured');
}

class NetworkFailure implements Failure {
  @override
  String get message => 'Please check your internet connection';
}

class TimeoutFailure extends Failure {
  TimeoutFailure({String? message})
      : super(message ??= 'Request timed out. Please try again.');
}

class UnknownFailure implements Failure {
  @override
  String get message => 'Something went wrong.Please try agaian';
}
