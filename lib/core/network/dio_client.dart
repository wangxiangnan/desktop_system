import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../constants/app_strings.dart';
import 'package:desktop_system/data/datasources/local/storage_datasource.dart';
import 'package:desktop_system/core/result/network_error.dart';
import 'package:desktop_system/core/services/error_handler.dart';

/// Recursively sort all map keys in ascending order.
dynamic _sortMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    final sorted = Map.fromEntries(
      value.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return sorted.map((k, v) => MapEntry(k, _sortMap(v)));
  }
  if (value is List) {
    return value.map(_sortMap).toList();
  }
  return value;
}

/// Generate sign value for request body.
///
/// 1. Recursively sort all keys in ascending order
/// 2. Serialize to JSON string
/// 3. Append salt "ctms"
/// 4. MD5 hash
String _generateSign(Map<String, dynamic> data) {
  final sorted = _sortMap(data);
  final plain = '${jsonEncode(sorted)}ctms';
  return md5.convert(utf8.encode(plain)).toString();
}

class ApiException implements Exception {
  final int code;
  final String message;

  ApiException(this.code, this.message);

  @override
  String toString() => message;
}

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(_ResponseInterceptor());
    _dio.interceptors.add(_ErrorInterceptor());

    if (AppConfig.debugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  set storageDataSource(StorageDataSource value) {
    _AuthInterceptor().storageDataSource = value;
  }

  set errorHandler(ErrorHandler value) {
    _ErrorInterceptor().errorHandler = value;
  }

  /// 获取Dio实例
  Dio get dio => _dio;

  /// GET请求
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// POST请求
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PUT请求
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// DELETE请求
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PATCH请求
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

class _AuthInterceptor extends Interceptor {
  static final _AuthInterceptor _instance = _AuthInterceptor._internal();

  factory _AuthInterceptor() {
    return _instance;
  }

  _AuthInterceptor._internal();

  StorageDataSource? _storageDataSource;

  set storageDataSource(StorageDataSource? value) {
    _storageDataSource = value;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storageDataSource?.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (options.method != 'GET') {
      final Map<String, dynamic> defaultData = {};
      options.data = options.data ?? defaultData;
      options.headers['sign'] = _generateSign(options.data);
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  static final _ErrorInterceptor _instance = _ErrorInterceptor._internal();

  factory _ErrorInterceptor() {
    return _instance;
  }

  _ErrorInterceptor._internal();

  ErrorHandler? _errorHandler;

  set errorHandler(ErrorHandler value) {
    _errorHandler = value;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorHandler = _errorHandler;
    if (errorHandler == null) {
      handler.next(err);
      return;
    }

    String msg;
    bool isUnauthorized = false;

    if (err.error is ApiException) {
      final apiErr = err.error as ApiException;
      msg = apiErr.message;
    } else if (err.response != null) {
      final statusCode = err.response!.statusCode ?? 0;
      final errorMsg = err.response!.data?['msg'] ?? err.message;
      switch (statusCode) {
        case 401:
          msg = AppStrings.errorSessionExpired;
          isUnauthorized = true;
          break;
        case 403:
          msg = AppStrings.errorForbidden;
          break;
        case 404:
          msg = AppStrings.errorNotFound;
          break;
        case 500:
          msg = AppStrings.errorServerError;
          break;
        default:
          msg = errorMsg ?? AppStrings.errorRequestFailed;
      }
    } else {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          msg = AppStrings.errorTimeout;
          break;
        case DioExceptionType.connectionError:
          msg = AppStrings.errorConnection;
          break;
        default:
          msg = err.message ?? AppStrings.errorNetworkFailed;
      }
    }

    errorHandler.reportError(NetworkError(
      message: msg,
      statusCode: err.response?.statusCode,
      isUnauthorized: isUnauthorized,
    ));

    handler.next(err);
  }
}

class _ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;
    if (data is Map) {
      final code = data['code'];
      if (code != null && code != 200) {
        final msg = data['msg'] ?? '请求失败';
        final err = DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: ApiException(code as int, msg),
          type: DioExceptionType.badResponse,
        );
        handler.reject(err, true);
        return;
      }
    }
    handler.next(response);
  }
}
