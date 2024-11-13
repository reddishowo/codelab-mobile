import 'package:get/get.dart';
import 'package:new_codelab_4/app/modules/mikrofon/controllers/mikrofon_controller.dart';


class MikrofonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MikrofonController>(
      () => MikrofonController(),
    );
  }
}
