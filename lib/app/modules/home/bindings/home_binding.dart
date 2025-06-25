import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService());
    }

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
