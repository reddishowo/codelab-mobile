import 'package:get/get.dart';
import 'package:new_codelab_4/app/modules/speaker/controllers/speaker_controller.dart';


class SpeakerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpeakerController>(
      () => SpeakerController(),
    );
  }
}
