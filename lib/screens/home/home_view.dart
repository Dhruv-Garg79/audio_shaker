import 'package:audio_shaker/models/sound_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sound Shaker"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(),
          child: ViewModelBuilder<HomeViewModel>.reactive(
              viewModelBuilder: () => HomeViewModel(),
              builder: (
                BuildContext context,
                HomeViewModel viewModel,
                Widget? child,
              ) {
                final length = viewModel.sounds.length + (viewModel.isBusy ? 1 : 0);
                return viewModel.sounds.isEmpty
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : ListView.separated(
                        controller: viewModel.scrollController,
                        itemBuilder: (ctx, index) {
                          if (index == viewModel.sounds.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
                          }
                          return SoundItemWidget(
                            sound: viewModel.sounds[index],
                            callback: (SoundModel sound) => viewModel.onSoundSelected(sound),
                          );
                        },
                        separatorBuilder: ((context, index) =>
                            index == viewModel.sounds.length - 1 ? const SizedBox.shrink() : const Divider()),
                        itemCount: length,
                      );
              }),
        ),
      ),
    );
  }
}

class SoundItemWidget extends StatelessWidget {
  final SoundModel sound;
  final void Function(SoundModel sound) callback;

  const SoundItemWidget({super.key, required this.sound, required this.callback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.music_note, color: Colors.amber),
      title: Text(
        sound.name,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 16,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "By: ",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            sound.username,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ),
      trailing: const Icon(Icons.play_arrow, color: Colors.grey),
      onTap: () => callback(sound),
    );
  }
}
