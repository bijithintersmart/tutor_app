import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tutor_app/core/constants/api_config.dart';
import 'package:tutor_app/core/routes/app_router.dart';
import 'package:tutor_app/core/routes/app_routes.dart';
import 'package:tutor_app/core/utils/local_storage.dart';
import 'package:tutor_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tutor_app/features/network/domain/entities/enum.dart';
import 'package:tutor_app/features/network/presentation/cubit/network_cubit.dart';
import 'package:tutor_app/features/network/presentation/cubit/network_state.dart';

import '../constants/storage_keys.dart';
import 'app_logger.dart';


class ApiClient {
  final Dio _dio;
  final NetworkCubit _networkCubit = AppRouter.networkCubit;
  final talker = AppLogger();
  static const Duration _defaultTimeout = Duration(seconds: 10);
  static final localStorage = GlobalLocalStorage();
  late final StreamSubscription<NetworkState> _networkSubscription;
  final Map<String, PendingRequest> _pendingRequests = {};
  static String _baseUrl = ApiConfig.baseUrl;
  Map<String, String> _headers = {};

  ApiClient({String? customBaseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: customBaseUrl ?? _baseUrl,
          connectTimeout: _defaultTimeout,
          receiveTimeout: _defaultTimeout,
        )) {
    if (customBaseUrl != null) {
      _baseUrl = customBaseUrl;
    }
    _initializeInterceptors();
    _listenToNetworkChanges();
  }

  void updateBaseUrl(String newBaseUrl) {
    _baseUrl = newBaseUrl;
    _dio.options.baseUrl = newBaseUrl;
  }

  void updateHeaders(Map<String, String> newHeaders) {
    _headers = newHeaders;
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: AppLogger.logError,
      retries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 3),
        Duration(seconds: 6),
      ],
      retryEvaluator: (error, attempt) {
        return error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.connectionError;
      },
    ));

    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_headers.isEmpty) {
          options.headers.addAll({
            'Authorization': 'Bearer ${_getAuthToken()}',
          });
        } else {
          options.headers.addAll(_headers);
        }
        return handler.next(options);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401) {
          logout();
        }

        if (_isNetworkError(e) &&
            _networkCubit.state.status == NetworkConnectionStatus.offline) {
          _storeRequestForLaterRetry(e.requestOptions);
          return handler.reject(e);
        }
        return handler.next(e);
      },
    ));
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout;
  }

  void _listenToNetworkChanges() {
    _networkSubscription = _networkCubit.stream.listen((state) {
      if (state.status == NetworkConnectionStatus.online) {
        _retryPendingRequests();
      }
    });
  }

  void _storeRequestForLaterRetry(RequestOptions options) {
    final requestId =
        '${DateTime.now().millisecondsSinceEpoch}-${options.path}';
    final pendingRequest = PendingRequest(
      id: requestId,
      method: options.method,
      endpoint: options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      headers: Map<String, dynamic>.from(options.headers),
      completer: Completer<Response>(),
    );

    _pendingRequests[requestId] = pendingRequest;
    AppLogger.logError(
        'Network unavailable. Request saved for later retry: ${options.method} ${options.path}');
  }

  Future<void> _retryPendingRequests() async {
    if (_pendingRequests.isEmpty) return;

    AppLogger.logError(
        'Internet connection restored. Retrying ${_pendingRequests.length} pending requests');

    final requestsToRetry = Map<String, PendingRequest>.from(_pendingRequests);
    _pendingRequests.clear();

    final sortedRequests = requestsToRetry.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (final request in sortedRequests) {
      try {
        final options = RequestOptions(
          path: request.endpoint,
          method: request.method,
          data: request.data,
          queryParameters: request.queryParameters,
          headers: request.headers,
          baseUrl: _dio.options.baseUrl,
        );

        final response = await _dio.fetch(options);
        request.completer.complete(response);
        AppLogger.logError(
            'Successfully retried request: ${request.method} ${request.endpoint}');
      } catch (e) {
        AppLogger.logError(
            'Failed to retry request: ${request.method} ${request.endpoint} — $e');
        if (e is DioException) {
          request.completer.completeError(e);
        } else {
          request.completer.completeError(DioException(
            requestOptions: RequestOptions(path: request.endpoint),
            error: e,
          ));
        }
      }
    }
  }

  void dispose() {
    try {
      _networkSubscription.cancel();
    } catch (_) {
      AppLogger.logError("Dispose failed: network subscription already closed");
    }
  }

  String _getAuthToken() {
    return localStorage.getString(StorageKeys.AUTH_TOKEN) ?? '';
  }

  Future<Response> _handleTimeout(
    Future<Response> Function() apiCall, {
    Duration? timeout,
  }) async {
    try {
      return await apiCall().timeout(
        timeout ?? _defaultTimeout,
        onTimeout: () {
          _navigateToTimeoutErrorScreen();
          throw TimeoutException('API Request Timed Out');
        },
      );
    } on TimeoutException {
      _navigateToTimeoutErrorScreen();
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        _navigateToTimeoutErrorScreen();
      }
      rethrow;
    }
  }

  void _navigateToTimeoutErrorScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = AppRouter.rootNavigatorKey.currentContext;
      if(context!=null){

      if (_networkCubit.state.status == NetworkConnectionStatus.offline) {
        GoRouter.of(context).go(AppRoutes.networkError);
      } else {
        GoRouter.of(context).go(AppRoutes.apiTimeOut);
}
      }
    });
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Duration? timeout,
  }) async {
    try {
      return await _handleTimeout(
        () => _dio.get(
          endpoint,
          queryParameters: queryParams,
          options: Options(headers: _headers),
        ),
        timeout: timeout,
      );
    } on DioException catch (e) {
      if (_isNetworkError(e) &&
          _networkCubit.state.status == NetworkConnectionStatus.offline) {
        return _queueOfflineRequest('GET', endpoint, queryParams: queryParams);
      }
      AppLogger.logError(
          'Method:GET \n Request:$endpoint\n Error Response:${e.response?.data}\n Error Message:${e.message}');
      rethrow;
    }
  }

  Future<Response> post(
    String endpoint, {
    Object? data,
    Duration? timeout,
  }) async {
    try {
      return await _handleTimeout(
        () => _dio.post(
          endpoint,
          data: data,
          options: Options(headers: _headers),
        ),
        timeout: timeout,
      );
    } on DioException catch (e) {
      if (_networkCubit.state.status == NetworkConnectionStatus.offline) {
        return _queueOfflineRequest('POST', endpoint, data: data);
      }
      AppLogger.logError(
          'Method:POST \n Request:$endpoint\n Error Response:${e.response?.data}\n Error Message:${e.message}');
      rethrow;
    }
  }

  Future<Response> put(
    String endpoint, {
    Object? data,
    Duration? timeout,
  }) async {
    try {
      return await _handleTimeout(
        () => _dio.put(
          endpoint,
          data: data,
          options: Options(headers: _headers),
        ),
        timeout: timeout,
      );
    } on DioException catch (e) {
      if (_networkCubit.state.status == NetworkConnectionStatus.offline) {
        return _queueOfflineRequest('PUT', endpoint, data: data);
      }

      AppLogger.logError(
          'Method:PUT \n Request:$endpoint\n Error Response:${e.response?.data}\n Error Message:${e.message}');
      rethrow;
    }
  }

  Future<Response> patch(
    String endpoint, {
    Object? data,
    Duration? timeout,
  }) async {
    try {
      return await _handleTimeout(
        () => _dio.patch(
          endpoint,
          data: data,
          options: Options(headers: _headers),
        ),
        timeout: timeout,
      );
    } on DioException catch (e) {
      if (_networkCubit.state.status == NetworkConnectionStatus.offline) {
        return _queueOfflineRequest('PATCH', endpoint, data: data);
      }
      AppLogger.logError(
          'Method:PATCH \n Request:$endpoint\n Error Response:${e.response?.data}\n Error Message:${e.message}');
      rethrow;
    }
  }

  Future<Response> delete(
    String endpoint, {
    Object? data,
    Duration? timeout,
  }) async {
    try {
      return await _handleTimeout(
        () => _dio.delete(
          endpoint,
          data: data,
          options: Options(headers: _headers),
        ),
        timeout: timeout,
      );
    } on DioException catch (e) {
      if (_networkCubit.state.status == NetworkConnectionStatus.offline) {
        return _queueOfflineRequest('DELETE', endpoint, data: data);
      }
      AppLogger.logError(
          'Method:DELETE \n Request:$endpoint\n Error Response:${e.response?.data}\n Error Message:${e.message}');
      rethrow;
    }
  }

  Future<Response> _queueOfflineRequest(String method, String endpoint,
      {Object? data, Map<String, dynamic>? queryParams}) {
    final requestId = '${DateTime.now().millisecondsSinceEpoch}-$endpoint';
    final completer = Completer<Response>();

    final pendingRequest = PendingRequest(
      id: requestId,
      method: method,
      endpoint: endpoint,
      data: data,
      queryParameters: queryParams,
      headers: {'Authorization': 'Bearer ${_getAuthToken()}'},
      completer: completer,
    );

    _pendingRequests[requestId] = pendingRequest;
    AppLogger.logError('Network offline. Request queued: $method $endpoint');

    return completer.future;
  }

  Future<void> logout() async {
    String? token = localStorage.getString(StorageKeys.AUTH_TOKEN);
    if (token != null) {
      AppRouter.rootNavigatorKey.currentContext!.read<AuthBloc>().add(
        AuthEvent.logout(),
      );
    }
  }
}

class PendingRequest {
  final String id;
  final String method;
  final String endpoint;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic> headers;
  final Completer<Response> completer;
  final DateTime timestamp;

  PendingRequest({
    required this.id,
    required this.method,
    required this.endpoint,
    this.data,
    this.queryParameters,
    required this.headers,
    required this.completer,
  }) : timestamp = DateTime.now();
}
