import 'package:audio_shaker/app/app.locator.dart';
import 'package:audio_shaker/app/app.logger.dart';
import 'package:audio_shaker/app/app.router.dart';
import 'package:audio_shaker/models/sound_model.dart';
import 'package:audio_shaker/respositories/sound_repo.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _logger = getLogger("HomeViewModel");
  final _soundsRepo = locator<SoundRepo>();
  final _navigationService = locator<NavigationService>();

  int _page = 1;
  final List<SoundModel> sounds = [];

  final scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  HomeViewModel() {
    _fetchAndUpdateList();
    scrollController.addListener(_onScroll);
  }

  onSoundSelected(SoundModel sound) {
    _navigationService.navigateToSoundDetailView(sound: sound);
  }

  _fetchAndUpdateList() async {
    _logger.d("fetching page $_page");
    setBusy(true);
    final res = await _soundsRepo.fetchSounds(_page);
    sounds.addAll(res);
    _logger.d("$_page ${sounds.length}");
    _page++;
    setBusy(false);
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold && !isBusy) {
      _fetchAndUpdateList();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
  }
}
