import 'dart:collection';

import 'package:audio_shaker/app/app.locator.dart';
import 'package:audio_shaker/models/sound_detail_model.dart';
import 'package:audio_shaker/models/sound_model.dart';
import 'package:audio_shaker/resources/sound_api_provider.dart';

class SoundRepo {
  final _provider = locator<SoundApiProvider>();
  final _cache = HashMap<int, SoundDetailModel>();

  Future<List<SoundModel>> fetchSounds(int offset) =>
      _provider.fetchSounds(offset);

  Future<SoundDetailModel> fetchSoundDetail(int soundId) async {
    if (!_cache.containsKey(soundId)) {
      _cache[soundId] = await _provider.fetchSoundDetails(soundId);
    }
    return _cache[soundId]!;
  }
}
