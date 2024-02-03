import 'package:audio_shaker/common/app_colors.dart';
import 'package:audio_shaker/models/sound_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'sound_detail_viewmodel.dart';

class SoundDetailView extends StackedView<SoundDetailViewModel> {
  final SoundModel sound;
  const SoundDetailView({Key? key, required this.sound}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SoundDetailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(),
        ),
      ),
    );
  }

  @override
  SoundDetailViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SoundDetailViewModel();
}
