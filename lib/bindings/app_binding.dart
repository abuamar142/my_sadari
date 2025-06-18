import 'package:get/get.dart';

import '../app/modules/schedule/controllers/schedule_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }

}