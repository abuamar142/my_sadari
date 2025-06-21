import 'package:get/get.dart';

import '../../../../core/services/screening_service.dart';
import '../controllers/screening_controller.dart';

class ScreeningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScreeningService>(() => ScreeningService());
    Get.lazyPut<ScreeningController>(() => ScreeningController());
  }
}
