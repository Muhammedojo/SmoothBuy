abstract class ApiResponse<T> {
  String? get message;
  String get responseCode;
  dynamic get errors;
  T? get data;
  int? get itemCount;
  String? get nextUrl;
  String? get previousUrl;

  bool get isSuccess; //=> responseCode == '100';

  String get defaultErrorMessage; // => 'an_error_occured';

  @override
  String toString() {
    return data?.toString() ?? '';
  }
}
