import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../network_layer/dio_client.dart';
import '../../network_layer/error_handling.dart';

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
