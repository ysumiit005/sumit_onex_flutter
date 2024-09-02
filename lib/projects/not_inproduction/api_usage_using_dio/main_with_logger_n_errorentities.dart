import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

///
/////
////
////
////
////
///// error_handling.dart
class ErrorEntity {
  final int code;
  final String message;

  ErrorEntity({required this.code, required this.message});
}

ErrorEntity createErrorEntity(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return ErrorEntity(code: -1, message: "Connection timed out");

    case DioExceptionType.sendTimeout:
      return ErrorEntity(code: -1, message: "Send timed out");

    case DioExceptionType.receiveTimeout:
      return ErrorEntity(code: -1, message: "Receive timed out");

    case DioExceptionType.badCertificate:
      return ErrorEntity(code: -1, message: "Bad SSL certificates");

    case DioExceptionType.badResponse:
      switch (error.response?.statusCode) {
        case 400:
          return ErrorEntity(code: 400, message: "Bad request");
        case 401:
          return ErrorEntity(code: 401, message: "Permission denied");
        case 500:
          return ErrorEntity(code: 500, message: "Server internal error");
        default:
          return ErrorEntity(
              code: error.response?.statusCode ?? -1,
              message: "Server bad response");
      }

    case DioExceptionType.cancel:
      return ErrorEntity(code: -1, message: "Request canceled");

    case DioExceptionType.connectionError:
      return ErrorEntity(code: -1, message: "Connection error");

    case DioExceptionType.unknown:
      return ErrorEntity(code: -1, message: "Unknown error");
  }
}

void onError(ErrorEntity eInfo) {
  print('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');
  switch (eInfo.code) {
    case 400:
      print("Server syntax error");
      break;
    case 401:
      print("You are denied to continue");
      break;
    case 500:
      print("Server internal error");
      break;
    default:
      print("Unknown error");
      break;
  }
}

//
//
//
//
// client
// dio_client.dart

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio.options.baseUrl = 'https://catfact.ninja';
    _dio.options.connectTimeout = const Duration(seconds: 5); // 5 seconds
    _dio.options.receiveTimeout = const Duration(seconds: 5); // 5 seconds

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        _logger.i('Request: ${options.method} ${options.uri}');
        handler.next(options); // Continue the request
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        _logger.i('Response: ${response.statusCode} ${response.data}');
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

//
//
//
//
//
// api service
// api_service.dart

class ApiService {
  final Dio _dio = DioClient().dio;
  final Logger _logger = Logger();

  Future<void> fetchCatFact() async {
    try {
      final response = await _dio.get('/fact');
      _logger.i('Cat Fact: ${response.data}');
    } on DioException catch (e) {
      final errorEntity = createErrorEntity(e);
      _logger.e('DioError response: ${errorEntity.message}');
      onError(errorEntity);
    } catch (e) {
      // Non-DioError errors
      _logger.e('Unexpected error: $e');
    }
  }
}

// main.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dio Singleton Example'),
        ),
        body: Center(
          child: FutureBuilder(
            future: ApiService().fetchCatFact(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('Check your console for output.');
              }
            },
          ),
        ),
      ),
    );
  }
}
