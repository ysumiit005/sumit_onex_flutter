import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sumit_onex_flutter/projects/inproduction/dio_singleton_template/utility/constants.dart';

import 'error_handling.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio.options.baseUrl = Constants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5); // 5 seconds
    _dio.options.receiveTimeout = const Duration(seconds: 5); // 5 seconds

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        _logger.t('Start of API call');
        _logger.i('Request: ${options.method} ${options.uri}');
        handler.next(options); // Continue the request
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        _logger.i('Response: ${response.statusCode} ${response.data}');
        _logger.t('End of API call');
        handler.next(response); // Continue with response
      },
      onError: (DioException e, ErrorInterceptorHandler handler) {
        final errorEntity = createErrorEntity(e);
        _logger.e('Error: ${errorEntity.message}');
        onError(errorEntity);
        handler.next(e); // Continue with error
      },
    ));
  }

  Dio get dio => _dio;
}
