import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//
//
//
//
//
//
//
// dio single ton
// dio_client.dart

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio _dio = Dio();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio.options.baseUrl = 'https://catfact.ninja';
    _dio.options.connectTimeout = const Duration(seconds: 5000); // 5 seconds
    _dio.options.receiveTimeout = const Duration(seconds: 5000); // 3 seconds

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        print('Request: ${options.method} ${options.uri}');
        handler.next(options); // Continue the request
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        print('Response: ${response.statusCode} ${response.data}');
        handler.next(response); // Continue with response
      },
      onError: (DioError e, ErrorInterceptorHandler handler) {
        print('Error: ${e.message}');
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
// dio service
// api_service.dart

class ApiService {
  final Dio _dio = DioClient().dio;

  Future<void> fetchCatFact() async {
    try {
      final response = await _dio.get('/fact');
      print('Cat Fact: ${response.data}');
    } on DioError catch (e) {
      if (e.response != null) {
        // The server responded with a non-2xx status code
        print(
            'DioError response: ${e.response?.statusCode} ${e.response?.data}');
      } else {
        // The request was made but no response was received
        print('DioError message: ${e.message}');
      }
    } catch (e) {
      // Non-DioError errors
      print('Unexpected error: $e');
    }
  }
}

//
//
//
//
//
//
//
// main
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
          title: Text('Dio Singleton Example'),
        ),
        body: Center(
          child: FutureBuilder(
            future: ApiService().fetchCatFact(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Check your console for output.');
              }
            },
          ),
        ),
      ),
    );
  }
}
