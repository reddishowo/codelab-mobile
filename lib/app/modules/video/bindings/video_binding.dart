import 'package:get/get.dart';

import '../../../data/services/VideoImage_controller.dart';

class VideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoImageController>(
      () => VideoImageController(),
    );
  }
}
