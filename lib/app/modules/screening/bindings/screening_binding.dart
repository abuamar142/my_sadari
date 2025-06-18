import 'package:get/get.dart';

import '../controllers/screening_controller.dart';

class ScreeningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScreeningController>(
      () => ScreeningController(),
    );
  }
}
