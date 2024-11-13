import 'package:get/get.dart';

import '../../../data/services/VideoImage_controller.dart';

class ImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoImageController>(
      () => VideoImageController(),
    );
  }
}
