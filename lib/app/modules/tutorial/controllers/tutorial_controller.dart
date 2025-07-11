import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/models/step_model.dart';
import '../../../../core/services/schedule_service.dart';
import '../../../styles/app_colors.dart';
import '../../../utils/app_images.dart';

class TutorialController extends GetxController {
  late final ScheduleService _scheduleService;

  @override
  void onInit() {
    super.onInit();
    try {
      _scheduleService = Get.find<ScheduleService>();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting ScheduleService in TutorialController: $e');
      }
    }
  }

  bool get isFromSchedule =>
      Get.arguments != null && Get.arguments['fromSchedule'] == true;

  Future<bool> markSadariCompleted({String? result}) async {
    try {
      // Check if schedule service is available
      if (!Get.isRegistered<ScheduleService>()) {
        if (kDebugMode) {
          print('ScheduleService not available');
        }
        return false;
      }

      return await _scheduleService.markSadariCompleted(result: result);
    } catch (e) {
      if (kDebugMode) {
        print('Error marking SADARI completed: $e');
      }
      return false;
    }
  }

  /// Get tutorial steps data
  List<StepModel> get tutorialSteps => [
    StepModel(
      title: 'Pemeriksaan Visual Awal',
      description:
          'Berdiri tegak di depan cermin dengan kedua tangan ke bawah di samping badan. Melihat dan membandingkan kedua payudara dalam bentuk, ukuran dan warna kulit.\n\nPerhatikan kemungkinan-kemungkinan berikut: Pembengkakan kulit, Posisi dan bentuk dari puting susu (apakah masuk ke dalam atau bengkak), Kulit kemerahan, keriput atau borok dan bengkak.',
      image: AppImages.tutor1,
      color: AppColors.pink,
    ),
    StepModel(
      title: 'Pemeriksaan dengan Tangan Terangkat',
      description:
          'Berdiri dengan mengangkat kedua lengan dan melihat kelainan seperti pada langkah 1 di atas.',
      image: AppImages.tutor2,
      color: AppColors.teal2,
    ),
    StepModel(
      title: 'Pemeriksaan Puting Susu',
      description:
          'Perhatikan tanda-tanda adanya pengeluaran cairan dari puting susu.',
      image: AppImages.tutor3,
      color: AppColors.purple1,
    ),
    StepModel(
      title: 'Pemeriksaan Berbaring',
      description:
          'Posisi berbaring, rabalah kedua payudara, payudara kiri dengan tangan kanan dan sebaliknya. Gunakan bagian dalam telapak tangan dari jari ke 2-4. Raba seluruh payudara dengan cara melingkar dari luar ke dalam atau dapat juga vertikal dari atas ke bawah.',
      image: AppImages.tutor4,
      color: AppColors.blue1,
    ),
    StepModel(
      title: 'Pemeriksaan Saat Mandi',
      description:
          'Saat mandi rabalah payudara dengan tangan yang licin karena sabun dalam posisi berdiri dan lakukan cara melingkar dari luar ke dalam atau dapat juga vertikal dari atas ke bawah.',
      image: AppImages.tutor5,
      color: AppColors.orange,
    ),
  ];

  /// Save SADARI result to active schedule
  void saveResultToSchedule(String result) {
    try {
      final activeSchedule = _scheduleService.activeSchedule;

      if (activeSchedule != null) {
        _scheduleService.updateScheduleResult(activeSchedule.id, result);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving result to schedule: $e');
      }
    }
  }
}
