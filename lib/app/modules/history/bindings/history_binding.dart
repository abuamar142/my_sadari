import 'package:get/get.dart';

import '../../../../core/services/screening_service.dart';
import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScreeningService>(() => ScreeningService());
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}
