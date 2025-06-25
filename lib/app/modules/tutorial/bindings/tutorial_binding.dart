import 'package:get/get.dart';

import '../../../../core/services/schedule_service.dart';
import '../controllers/tutorial_controller.dart';

class TutorialBinding extends Bindings {
  @override
  void dependencies() {
    // Register ScheduleService if not already registered
    if (!Get.isRegistered<ScheduleService>()) {
      Get.lazyPut<ScheduleService>(() => ScheduleService(), fenix: true);
    }

    Get.lazyPut<TutorialController>(() => TutorialController());
  }
}
