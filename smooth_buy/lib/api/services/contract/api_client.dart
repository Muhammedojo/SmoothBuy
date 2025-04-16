
import 'package:fpdart/fpdart.dart';

import '../../exceptions/contracts/failure.dart';
import '../dio_client.dart';
import 'api_response.dart';


abstract class IApiClient {
  void setToken(String token);
  void removeToken();
  void cancelRequest();

  Future<Either<Failure, ApiResponse<T>>> request<T>(
    String url,
    MethodType method,
    T Function(dynamic, {String? realUri}) fromJson,
    dynamic params, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headerOption,
    authInterceptor,
  });

  Future<Either<Failure, ApiResponse<T>>> multipartRequest<T>(
    String url,
    MethodType method,
    T Function(dynamic, {String? realUri}) fromJson,
    dynamic params, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headerOption,
  });

  Future<Either<Failure, ApiResponse<T>>> download<T>(
      String url, String fileName, T Function(dynamic) fromJson, dynamic params,
      {Map<String, dynamic>? queryParameters});
}
