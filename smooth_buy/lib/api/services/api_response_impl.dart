
import 'contract/api_response.dart';

class ApiResponseImpl<T> implements ApiResponse<T> {
  final T? _data;
  final String? _message;
  final dynamic _errors;
  final String? _responseCode;
  final int? count;
  final String? next;
  final String? previous;

  ApiResponseImpl(this._data, this._errors, this._message, this._responseCode,
      {this.count, this.next, this.previous});

  @override
  T? get data => _data;

  @override
  String get responseCode => _responseCode ?? '';

  @override
  String? get message => _message;

  @override
  dynamic get errors => _errors == null ? "" : _errors.toString();

  @override
  int? get itemCount => count;

  @override
  String? get nextUrl => next;

  @override
  String? get previousUrl => previous;

  @override
  bool get isSuccess => responseCode == '100';

  @override
  String get defaultErrorMessage => 'an_error_occured';

  @override
  String toString() {
    return 'ApiResponseImpl<$T>(${data.toString()})';
  }
}
