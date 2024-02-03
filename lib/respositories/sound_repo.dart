import 'package:audio_shaker/app/app.locator.dart';
import 'package:audio_shaker/models/sound_model.dart';
import 'package:audio_shaker/resources/sound_api_provider.dart';

class SoundRepo {
  final _provider = locator<SoundApiProvider>();

  Future<List<SoundModel>> fetchSounds(int offset) =>
      _provider.fetchSounds(offset);
}
