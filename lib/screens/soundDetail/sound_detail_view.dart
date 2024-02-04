import 'dart:developer';

import 'package:audio_shaker/models/sound_model.dart';
import 'package:audio_shaker/screens/soundDetail/sound_detail_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:stacked/stacked.dart';

class SoundDetailView extends StatelessWidget {
  final SoundModel sound;
  const SoundDetailView({super.key, required this.sound});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sound.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(),
          child: ViewModelBuilder<acceleration>.reactive(
            viewModelBuilder: () => acceleration(sound.id),
            builder: (
              BuildContext context,
              acceleration model,
              Widget? child,
            ) {
              return model.isBusy
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: model.sound.imageUrl,
                        ),
                        StreamBuilder<AccelerometerEvent>(
                          stream: accelerometerEventStream(),
                          builder: (context, snapshot) => Text(
                            "${snapshot.data?.x}, ${snapshot.data?.y}, ${snapshot.data?.z}",
                          ),
                        ),
                        StreamBuilder<GyroscopeEvent>(
                          stream: gyroscopeEventStream(),
                          builder: (context, snapshot) => Text(
                            "${snapshot.data?.x}, ${snapshot.data?.y}, ${snapshot.data?.z}",
                          ),
                        ),
                        ControlButtons(model.player)
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {},
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text(
              "${snapshot.data?.toStringAsFixed(1)}x",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
