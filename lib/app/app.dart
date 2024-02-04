import 'package:audio_shaker/resources/sound_api_provider.dart';
import 'package:audio_shaker/respositories/sound_repo.dart';
import 'package:audio_shaker/screens/home/home_view.dart';
import 'package:audio_shaker/screens/soundDetail/sound_detail_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  logger: StackedLogger(),
  routes: [
    MaterialRoute(page: HomeView, initial: true),
    MaterialRoute(page: SoundDetailView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SoundApiProvider),
    LazySingleton(classType: SoundRepo),
  ],
)
class App {}
