import 'dart:math';

import 'package:audio_shaker/models/sound_model.dart';
import 'package:audio_shaker/screens/soundDetail/sound_detail_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stacked/stacked.dart';

class SoundDetailView extends StatelessWidget {
  final SoundModel sound;
  const SoundDetailView({super.key, required this.sound});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.width * 0.7,
                                imageUrl: model.sound.imageUrl,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                sound.name,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              model.sound.username,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        StreamBuilder<Duration>(
                          stream: model.player.positionStream,
                          builder: (context, snapshot) {
                            final val = snapshot.data?.inMilliseconds.toDouble() ?? 0;
                            final max = model.player.duration?.inMilliseconds.toDouble() ?? 0;
                            return Column(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    overlayShape: SliderComponentShape.noOverlay,
                                    overlayColor: Colors.grey,
                                    thumbColor: Colors.grey,
                                    activeTrackColor: Colors.black,
                                    thumbShape: SliderComponentShape.noThumb,
                                  ),
                                  child: Slider(
                                    value: min(val, max),
                                    max: max,
                                    onChanged: (val) {},
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data?.toString().substring(6, 9) ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      model.player.duration?.toString().substring(6, 9) ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ControlButtons(model.player),
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
        StreamBuilder<LoopMode>(
            stream: player.loopModeStream,
            builder: (context, snapshot) {
              final isOff = player.loopMode == LoopMode.off;
              return IconButton(
                icon: Icon(
                  Icons.repeat_one_rounded,
                  color: isOff ? Colors.grey : Colors.white,
                ),
                onPressed: () async {
                  await player.setLoopMode(isOff ? LoopMode.one : LoopMode.off);
                  if (isOff) {
                    player.play();
                  }
                },
              );
            }),

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
            if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_circle),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause_circle),
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
