import 'package:audio_shaker/models/sound_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
                final length =
                    viewModel.sounds.length + (viewModel.isBusy ? 1 : 0);
                return viewModel.sounds.isEmpty
                    ? const Center(child: CircularProgressIndicator())
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
                            callback: (SoundModel sound) =>
                                viewModel.onSoundSelected(sound),
                          );
                        },
                        separatorBuilder: ((context, index) =>
                            index == viewModel.sounds.length - 1
                                ? const SizedBox.shrink()
                                : const Divider()),
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

  const SoundItemWidget(
      {super.key, required this.sound, required this.callback});

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
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Icon(Icons.music_note, color: Colors.amber),
    //         const SizedBox(
    //           width: 4,
    //         ),
    //         Expanded(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               SizedBox(
    //                 width: MediaQuery.of(context).size.width * 0.7,
    //                 child: Text(
    //                   sound.name,
    //                   style: const TextStyle(
    //                     overflow: TextOverflow.ellipsis,
    //                     fontSize: 16,
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 4,
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   const Text(
    //                     "By: ",
    //                     style: TextStyle(fontSize: 12),
    //                   ),
    //                   Text(
    //                     sound.username,
    //                     style: const TextStyle(color: Colors.red, fontSize: 12),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Icon(Icons.play_arrow, color: Colors.grey),
    //         const SizedBox(
    //           width: 16,
    //         ),
    //       ],
    //     ),
    //     const SizedBox(height: 8),
    //     // SizedBox(
    //     //   height: 30,
    //     //   child: ListView.builder(
    //     //     itemCount: sound.tags.length,
    //     //     itemBuilder: (ctx, i) {
    //     //       return Padding(
    //     //         padding: const EdgeInsets.only(right: 8.0),
    //     //         child: Container(
    //     //           alignment: Alignment.center,
    //     //           padding: const EdgeInsets.symmetric(
    //     //             horizontal: 8,
    //     //             vertical: 4,
    //     //           ),
    //     //           decoration: BoxDecoration(
    //     //             borderRadius: BorderRadius.circular(24),
    //     //             border: Border.all(
    //     //               color: Colors.white,
    //     //               width: 0.6,
    //     //             ),
    //     //           ),
    //     //           child: Text(
    //     //             sound.tags[i],
    //     //             style: const TextStyle(
    //     //               fontSize: 11,
    //     //             ),
    //     //           ),
    //     //         ),
    //     //       );
    //     //     },
    //     //     scrollDirection: Axis.horizontal,
    //     //   ),
    //     // ),
    //     const Divider(),
    //     SizedBox()
    //   ],
    // );
  }
}
