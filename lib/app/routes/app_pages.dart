import 'package:get/get.dart';
import 'package:new_codelab_4/app/modules/home/home_view.dart';
import 'package:new_codelab_4/app/modules/mikrofon/bindings/mikrofon_binding.dart';
import 'package:new_codelab_4/app/modules/mikrofon/views/mikrofon_view.dart';
import 'package:new_codelab_4/app/modules/speaker/bindings/speaker_binding.dart';

import '../modules/image/views/image_view.dart';
import '../modules/speaker/views/speaker_view.dart';
import '../modules/video/bindings/video_binding.dart';
import '../modules/video/views/video_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const VIDEO = Routes.VIDEO;
  static const IMAGE = Routes.IMAGE;
  static const SPEAKER = Routes.SPEAKER;
  static const MIKROFON = Routes.MIKROFON;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: _Paths.IMAGE,
      page: () => const ImageView(),
      binding: VideoBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO,
      page: () => const VideoView(),
      binding: VideoBinding(),
    ),
    GetPage(
      name: _Paths.SPEAKER,
      page: () => const SpeakerView(),
      binding: SpeakerBinding(),
    ),
    GetPage(
      name: _Paths.MIKROFON,
      page: () => const MikrofonView(),
      binding: MikrofonBinding(),
    ),
  ];
}
