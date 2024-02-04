import 'dart:math' as math;

import 'package:audio_shaker/app/app.locator.dart';
import 'package:audio_shaker/app/app.logger.dart';
import 'package:audio_shaker/models/sound_detail_model.dart';
import 'package:audio_shaker/respositories/sound_repo.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:stacked/stacked.dart';

class acceleration extends BaseViewModel {
  final _logger = getLogger("HomeViewModel");
  final _soundsRepo = locator<SoundRepo>();

  final player = AudioPlayer();
  double _playSpeed = 1.0;
  final _speedStep = 0.2; // by how much we change speed on each action

  late SoundDetailModel sound;

  // Data we are getting from device sensors
  late AccelerometerEvent aEvent;
  late GyroscopeEvent gEvent;

  // we will use this timestamp, to block the next action for 1s
  DateTime _lastAction = DateTime.now();

  // to store values of last 2 acceleration points for x and y axis
  final _accWaitDuration = const Duration(milliseconds: 400);
  DateTime _accUpdateTime = DateTime.now();
  final _accX = [0.0, 0.0];
  final _accY = [0.0, 0.0];

  acceleration(int soundId) {
    _fetchAndStart(soundId);
    accelerometerEventStream().listen((AccelerometerEvent event) {
      aEvent = event;
    });
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      gEvent = event;

      if (DateTime.now().difference(_lastAction) > const Duration()) {
        _onSensorDataChange();
      }
    });
  }

  // check if we need to do any action based on sensor data
  // if we do any action, update _lastAction timestamp, so that we can block next action for sometime
  _onSensorDataChange() async {
    // angular acceleration along respective axis
    double gx = gEvent.x, gy = gEvent.y, gz = gEvent.z;
    // acceleration along respective axis
    double ax = aEvent.x, ay = aEvent.y;

    if (gx > 5 || gy > 5 || gz > 5) {
      _logger.d("g event ${gx.toStringAsFixed(2)} ${gy.toStringAsFixed(2)} ${gz.toStringAsFixed(2)}");
    }

    if (DateTime.now().difference(_accUpdateTime) > _accWaitDuration) {
      _accX[0] = _accX[1];
      _accX[1] = ax;

      _accY[0] = _accY[1];
      _accY[1] = ay;

      _accUpdateTime = DateTime.now();
    }

    // for play/pause audio loop
    // if gx is greater than 4, and gz is small to avoid collision with other actions
    // and ay goes from greater than 5 to less than -1.
    if (gx > 5 && gz.abs() < 2 && _accY[0] > 5 && ay < -1) {
      _logger.v("acc eve $gx $gz $_accY $ay");

      player.playing ? player.pause() : player.play();
      _lastAction = DateTime.now().add(const Duration(seconds: 1));
      setBusy(false);
    }

    final isLeft = (gz > 6 && ax < -7 && ax > -20); // to check if we move from center to left
    final isRight = (gz < -6 && ax > 7 && ax < 20); // to check if we move from center to right

    // for changing speed of the audio loop
    // _accX[0].abs() < 2 -> to check if we start from center
    if (_accX[0].abs() < 2 && isLeft || isRight) {
      _logger.d("acc event $isLeft $isRight $gz $_accX $ax");

      _lastAction = DateTime.now().add(const Duration(
        seconds: 2,
      ));

      // _playSpeed needs to be in range 0 > _playSpeed < 2
      if (isLeft) _playSpeed = math.max(_speedStep, _playSpeed - _speedStep);
      if (isRight) _playSpeed = math.min(1.8, _playSpeed + _speedStep);

      _logger.d("acc event play speed $_playSpeed");

      if (_playSpeed >= 0.2 && _playSpeed <= 1.8) {
        await player.setSpeed(_playSpeed);
        setBusy(false);
      }
    }
  }

  _fetchAndStart(int soundId) async {
    setBusy(true);
    sound = await _soundsRepo.fetchSoundDetail(soundId);
    setBusy(false);
    await player.setUrl(sound.assetUrl);
    player.setLoopMode(LoopMode.one);
    player.play();
  }

  @override
  void dispose() {
    // we only need to dispose player
    // and not sensor streams as they are in global context and we need to use them again whenever this screen is opened
    player.dispose();
    super.dispose();
  }
}
