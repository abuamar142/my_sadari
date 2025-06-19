import 'package:get/get.dart';

import '../../../../core/services/schedule_service.dart';
import '../controllers/schedule_controller.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    // Register service
    Get.lazyPut<ScheduleService>(() => ScheduleService(), fenix: true);

    // Register controller
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}
