import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sumit_onex_flutter/projects/inproduction/dio_singleton_template/utility/constants.dart';

import '../../models/catbreeds_model.dart';
import '../../models/catfact_model.dart';
import '../../network_layer/dio_client.dart';
import '../../network_layer/error_handling.dart';

class CatApiService {
  final Dio _dio = DioClient().dio;
  final Logger _logger = Logger();

  Future<CatfactModel> fetchCatFact() async {
    try {
      final response = await _dio.get(Constants.catFactsUrl);
      var responseJsonDecoded = jsonDecode(response.toString());

      _logger.i('Cat Fact: ${responseJsonDecoded}');
      return CatfactModel.fromJson(responseJsonDecoded);
    } on DioException catch (e) {
      final errorEntity = createErrorEntity(e);
      _logger.e('DioError response: ${errorEntity.message}');
      onError(errorEntity);
      throw Exception(e);
    } catch (e) {
      // Non-DioError errors
      _logger.e('Unexpected error: $e');
      throw Exception(e);
    }
  }

  Future<CatBreedsModel> fetchCatBreeds() async {
    try {
      final response = await _dio.get(Constants.catBreedsUrl);
      var responseJsonDecoded = jsonDecode(response.toString());

      _logger.i('Cat Breeds: ${responseJsonDecoded["per_page"]}');
      return CatBreedsModel.fromJson(responseJsonDecoded);
    } on DioException catch (e) {
      final errorEntity = createErrorEntity(e);
      _logger.e('DioError response: ${errorEntity.message}');
      onError(errorEntity);
      throw Exception(e);
    } catch (e) {
      // Non-DioError errors
      _logger.e('Unexpected error: $e');
      throw Exception(e);
    }
  }
}
