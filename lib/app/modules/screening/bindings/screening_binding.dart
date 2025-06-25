import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/schedule_service.dart';
import '../../../../core/services/screening_service.dart';
import '../controllers/screening_controller.dart';

class ScreeningBinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthService if not already registered
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService());
    }

    // Register ScheduleService if not already registered
    if (!Get.isRegistered<ScheduleService>()) {
      Get.lazyPut<ScheduleService>(() => ScheduleService(), fenix: true);
    }

    Get.lazyPut<ScreeningService>(() => ScreeningService());
    Get.lazyPut<ScreeningController>(() => ScreeningController());
  }
}
