import 'contracts/failure.dart';

class ValidationFailure implements Failure {
  late String message;
  ValidationFailure(this.message);

  @override
  String failureMessage() {
    return message;
  }
}

class CancelFailure implements Failure {
  @override
  String failureMessage() {
    return "request_to_server_was_cancelled";
  }
}

class ServerFailure implements Failure {
  @override
  String failureMessage() {
    return "something_went_wrong_and_your_request_could_not_be_completed";
  }
}

class InternetFailure implements Failure {
  @override
  String failureMessage() {
    return "no_internet_connection";
  }
}

class BadResponseFailure implements Failure {
  final String? message;

  BadResponseFailure({this.message});

  @override
  String failureMessage() {
    return message ?? "bad_response_from_the_server";
  }
}

class ConnectionTimeOutFailure implements Failure {
  @override
  String failureMessage() {
    return "connection_timeout_with_server";
  }
}

class ReceivedTimeOutFailure implements Failure {
  @override
  String failureMessage() {
    return "";
  }
}

class SendTimeOutFailure implements Failure {
  @override
  String failureMessage() {
    return "send_timeout_in_connection_with_server";
  }
}

class ConnectionFailure implements Failure {
  @override
  String failureMessage() {
    return "connection_to_server_failed_due_to_internet_connection";
  }
}

class BadCertificateFailure implements Failure {
  @override
  String failureMessage() {
    return "bad_certificate";
  }
}

class BadRequestFailure implements Failure {
  @override
  String failureMessage() {
    return "bad_request_failure";
  }
}

class UnknownFailure implements Failure {
  final String? message;

  UnknownFailure({this.message});

  @override
  String failureMessage() {
    return message ?? "unknown_error";
  }
}
