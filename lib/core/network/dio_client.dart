import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/app_config.dart';
import 'package:desktop_system/routing/app_router.dart';
import 'package:desktop_system/data/datasources/local/storage_datasource.dart';

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

  void setStorageDataSource(StorageDataSource storageDataSource) {
    _AuthInterceptor().setStorageDataSource(storageDataSource);
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

  void setStorageDataSource(StorageDataSource storageDataSource) {
    _storageDataSource = storageDataSource;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storageDataSource?.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
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
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    BuildContext? context = AppRouter.navigatorKey.currentContext;
    String msg;
    int? errorCode;

    if (err.error is ApiException) {
      final apiErr = err.error as ApiException;
      errorCode = apiErr.code;
      msg = apiErr.message;
    } else if (err.response != null) {
      final statusCode = err.response!.statusCode ?? 0;
      errorCode = err.response!.data?['code'];
      final errorMsg = err.response!.data?['msg'] ?? err.message;
      switch (statusCode) {
        case 401:
          msg = '登录已过期，请重新登录';
          context?.go('/login');
          break;
        case 403:
          msg = '没有权限访问该资源';
          break;
        case 404:
          msg = '请求的资源不存在';
          break;
        case 500:
          msg = '服务器内部错误';
          break;
        default:
          msg = errorMsg ?? '请求失败';
      }
    } else {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          msg = '网络连接超时，请检查网络';
          break;
        case DioExceptionType.connectionError:
          msg = '网络连接失败，请检查网络';
          break;
        default:
          msg = err.message ?? '网络请求失败';
      }
    }

  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

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
