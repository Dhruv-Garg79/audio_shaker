import 'package:audio_shaker/app/app.locator.dart';
import 'package:audio_shaker/app/app.logger.dart';
import 'package:audio_shaker/models/sound_model.dart';
import 'package:audio_shaker/resources/dto/sound_list_response.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class SoundApiProvider {
  final _logger = getLogger('SoundApiProvider');
  final _apiClient = Dio()
    ..interceptors.addAll(
      [
        LogInterceptor(),
      ],
    );
  final _baseUrl = "https://freesound.org/apiv2";
  final _token = "ZO8Ny9tMBLKCQw3DOAIhYD8glC9IUTkh8gnDGuQW";

  Future<List<SoundModel>> fetchSounds(int page) async {
    try {
      final response = await _apiClient.get(
        '$_baseUrl/search/text',
        queryParameters: {"query": "beat", "page": page, "token": _token},
      );
      return SoundListResponse.fromMap(response.data).results;
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }
}
