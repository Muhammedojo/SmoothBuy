import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../exceptions/api_exception.dart';
import '../exceptions/contracts/failure.dart';
import '../network/network_info.dart';
import 'api_response_impl.dart';
import 'contract/api_client.dart';
import 'contract/api_response.dart';
import 'endpoints.dart';
import 'interceptor.dart';


class DioClient implements IApiClient {
  late Dio _dio;
  late CancelToken _cancelToken;
  late NetworkInfo networkInfo;

  factory DioClient.createInstance(NetworkInfo value) {
    return DioClient(value);
  }

  @override
  setToken(String token) {
    _dio.options.headers['Authorization'] = 'WB3 $token';
  }

  @override
  clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  @override
  void cancelRequest(){
      _cancelToken.cancel("Request was manually canceled.");
  }

  DioClient(this.networkInfo) {
    _dio = Dio(
      // BaseOptions(baseUrl: env.baseUrl)
      BaseOptions(
        baseUrl: BASE_API,
        headers: {
          "content-type": "application/json",
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 1),
        sendTimeout: const Duration(minutes: 1),
        // followRedirects: true,
      ),
    )
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..options.sendTimeout = const Duration(seconds: 60)
      // ..interceptors.add(DioFirebasePerformanceInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: true,
            error: true,
            compact: true,
            maxWidth: 90),
      );
  }

  @override
  Future<Either<Failure, ApiResponse<T>>> request<T>(
      String url,
      MethodType method,
      T Function(dynamic, {String? realUri}) fromJson,
      dynamic params,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headerOption,
      authInterceptor = const DioClientInterceptor()}) async {
    try {
      if (authInterceptor != null) {
        _dio.interceptors.add(authInterceptor);
      }

      _cancelToken = CancelToken();
      Response response;
      // if (await networkInfo.isConnected()) {
      switch (method) {
        case MethodType.post:
          response = await _dio.post(
            url,
            data: params,
            queryParameters: queryParameters,
            options: Options(headers: headerOption),
            cancelToken: _cancelToken,
          );
          break;
        case MethodType.delete:
          response = await _dio.delete(url,
              data: params, queryParameters: queryParameters, cancelToken: _cancelToken,);
          break;
        case MethodType.patch:
          response = await _dio.patch(url,
              data: params, queryParameters: queryParameters, cancelToken: _cancelToken,);
          break;
        case MethodType.get:
          response = await _dio.get(url,
              data: params, queryParameters: queryParameters, cancelToken: _cancelToken,);
          break;
        case MethodType.put:
          response = await _dio.put(url,
              data: params, queryParameters: queryParameters, cancelToken: _cancelToken,);
          break;
      }
      if (response.data != null && response.data.containsKey('responseCode')) {
        if (_isRequestSuccessful(
            response.statusCode.toString(), response.data['responseCode'])) {
          return response.data.containsKey("data")
              ? (response.data.containsKey("count")
              ? right(ApiResponseImpl<T>(
            fromJson(response.data['data']),
            response.data['errors'] ?? response.data['detail'] ?? '',
            response.data['message'] ?? '',
            response.data['responseCode'] ?? '',
            count: response.data['count'] ?? '',
            next: response.data['next'] ?? '',
            previous: response.data['prev'] ?? '',
          ))
              : right(ApiResponseImpl<T>(
            fromJson(response.data['data']),
            response.data['errors'] ?? response.data['detail'] ?? '',
            response.data['message'] ?? '',
            response.data['responseCode'] ?? '500',
            count: response.data['count'] ?? 0,
            next: response.data['next'] ?? '',
            previous: response.data['prev'] ?? '',
          )))
              : right(ApiResponseImpl<T>(
            fromJson(response.data),
            response.data['errors'] ?? response.data['detail'] ?? '',
            response.data['message'] ?? '',
            response.data['responseCode'] ?? 100,
            count: 0,
            next: response.data['next'] ?? '',
            previous: response.data['prev'] ?? '',
          ));
        }
      }

      return response.data != null && (response.data.containsKey('errors') || response.data.containsKey('detail') )
          ? left(ValidationFailure(_formatApiErrorMessage(
          response.data['errors'] ?? response.data['detail'], response.data['message'])))
          : left(ServerFailure());
    } on DioException catch (dioError) {
      return left(_handleDioError(dioError));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<T>>> multipartRequest<T>(
      String url,
      MethodType method,
      T Function(dynamic, {String? realUri}) fromJson,
      dynamic params,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headerOption,
      authInterceptor = const DioClientInterceptor()}) async {
    try {
      if (authInterceptor != null) {
        _dio.interceptors.add(authInterceptor);
      }
      _cancelToken = CancelToken();
      Response response = await _dio.post(url,
          data: params,
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
          }),
        cancelToken: _cancelToken,
      );

      if (response.data != null && response.data.containsKey('responseCode')) {
        if (_isRequestSuccessful(
            response.statusCode.toString(), response.data['responseCode'])) {
          return response.data.containsKey("data")
              ? (response.data.containsKey("count")
                  ? right(ApiResponseImpl<T>(
                      fromJson(response.data['data']),
                      response.data['errors'] ?? response.data['detail'] ?? '',
                      response.data['message'] ?? '',
                      response.data['responseCode'] ?? '',
                      count: response.data['count'] ?? '',
                      next: response.data['next'] ?? '',
                      previous: response.data['prev'] ?? '',
                    ))
                  : right(ApiResponseImpl<T>(
                      fromJson(response.data['data']),
                      response.data['errors'] ?? response.data['detail'] ?? '',
                      response.data['message'] ?? '',
                      response.data['responseCode'] ?? '500',
                      count: response.data['count'] ?? 0,
                      next: response.data['next'] ?? '',
                      previous: response.data['prev'] ?? '',
                    )))
              : right(ApiResponseImpl<T>(
                  fromJson(response.data),
                  response.data['errors'] ?? response.data['detail'] ?? '',
                  response.data['message'] ?? '',
                  response.data['responseCode'] ?? 100,
                  count: 0,
                  next: response.data['next'] ?? '',
                  previous: response.data['prev'] ?? '',
                ));
        }
      }

      return response.data != null && (response.data.containsKey('errors') || response.data.containsKey('detail') )
          ? left(ValidationFailure(_formatApiErrorMessage(
              response.data['errors'] ?? response.data['detail'], response.data['message'])))
          : left(ServerFailure());
    } on DioException catch (dioError) {
      return left(_handleDioError(dioError));
    }
  }

  bool _isRequestSuccessful(String? statusCode, String responseCode) =>
      (statusCode == '200' || statusCode == '201') &&
      (responseCode == '100' || responseCode == '200');

  Failure _handleDioError(DioException error) {
    if (error.error != null && error.error is SocketException) {
      return InternetFailure();
    }

    late Failure failureType;
    switch (error.type) {
      case DioExceptionType.cancel:
        failureType = CancelFailure();
        break;
      case DioExceptionType.connectionTimeout:
        failureType = ConnectionTimeOutFailure();
        break;
      case DioExceptionType.connectionError:
        failureType = ConnectionFailure();
        break;
      case DioExceptionType.badCertificate:
        failureType = BadCertificateFailure();
        break;
      case DioExceptionType.badResponse:
        if (error.response != null && (error.response!.statusCode == 500 || error.response!.statusCode == 404)) {
          failureType = ServerFailure();
        } else {
          var response = error.response;
          if (response?.data != null ){
            if(response?.data.containsKey('errors')) {
              failureType = ValidationFailure(_formatApiErrorMessage(
                  response!.data['errors'], response.data['message']));
            }else{
              failureType = ValidationFailure(response?.data['message']);
            }
          } else {
            failureType = BadResponseFailure(message: error.message);
          }
        }
        break;
      case DioExceptionType.receiveTimeout:
        failureType = ReceivedTimeOutFailure();
        break;
      case DioExceptionType.sendTimeout:
        failureType = SendTimeOutFailure();
        break;
      case DioExceptionType.unknown:
        failureType = ServerFailure();
        break;
    }
    // if (error.error == null) {
    //   failureType = BadResponseFailure(message: 'Server');
    // }
    return failureType;
  }

  @override
  Future<Either<Failure, ApiResponse<T>>> download<T>(
      String url, String fileName, T Function(dynamic p1) fromJson, params,
      {Map<String, dynamic>? queryParameters}) {
    // TODO: implement download
    throw UnimplementedError();
  }

  @override
  void removeToken() {
    // TODO: implement removeToken
  }
}

class ApiResponseData<T> {
  final T? data;
  final String? errorMessage;

  ApiResponseData({this.data, this.errorMessage});
}

String errorMEssage(dynamic data) {
  if (data.runtimeType == String) {
    return data;
  } else {
    return 'An error occurred';
  }
}

String _formatApiErrorMessage(dynamic response, String message) {
  if (response != null && response.toString().trim().isNotEmpty) {
    return response
        .toString()
        .replaceAll("{", '')
        .replaceAll("}", '')
        .replaceAll("_", " ")
        .replaceAll("'", "")
        .replaceAll("\"", "")
        .replaceAll("[", '')
        .replaceAll("]", '')
        .replaceAll("non field errors:", "")
        .replaceAll("Farmer Create", "")
        .replaceAll("Ok", "")
        .trim();
  }
  return message;
}

enum MethodType { post, get, put, delete, patch }
