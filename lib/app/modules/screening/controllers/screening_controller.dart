import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/schedule_service.dart';
import '../../../../core/services/screening_service.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_snackbar.dart';
import '../models/screening_data_model.dart';
import '../models/screening_list_model.dart';

class Statement {
  final String text;
  final bool isMajor;

  Statement(this.text, this.isMajor);
}

class ScreeningController extends GetxController {
  final storage = GetStorage();
  late final AuthService _authService;
  late final ScreeningService _screeningService;
  late final ScheduleService scheduleService;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingData = false.obs;
  final RxBool isEditMode = false.obs;
  final Rx<ScreeningItemWithResponden?> existingScreening =
      Rx<ScreeningItemWithResponden?>(null);

  bool get isFromSchedule =>
      Get.arguments != null && Get.arguments['fromSchedule'] == true;

  final statements = <Statement>[
    Statement('Usia saat menstruasi pertama dibawah 12 tahun', false),
    Statement('Belum pernah melahirkan anak', false),
    Statement('Belum pernah menyusui anak', false),
    Statement('Menyusui kurang dari 6 bulan', false),
    Statement('Melahirkan anak pertama diatas usia 35 tahun', false),
    Statement('Pernah atau sedang menggunakan KB PIL/Suntik', false),
    Statement(
      'Menopause (tidak menstruasi selama 1 tahun) diusia lebih dari 50 tahun',
      true,
    ),
    Statement('Pernah menderita tumor jinak payudara', true),
    Statement('Riwayat keluarga dengan kanker payudara', true),
    Statement('Mengkonsumsi alkohol', false),
    Statement('Merokok', false),
    Statement('Obesitas', false),
  ];

  late final List<RxInt> answers;
  @override
  void onInit() {
    super.onInit();

    try {
      _authService = Get.find<AuthService>();
      _screeningService = Get.find<ScreeningService>();
      scheduleService = Get.find<ScheduleService>();
      answers = List<RxInt>.generate(statements.length, (_) => 0.obs);

      // Delay the data fetching to avoid blocking UI initialization
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchExistingScreeningData();
      });

      // Add timeout fallback to ensure UI is not stuck in loading state
      Future.delayed(Duration(seconds: 5), () {
        if (isLoadingData.value) {
          if (kDebugMode) {
            print('Loading timeout - forcing loading state to false');
          }
          isLoadingData.value = false;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error in ScreeningController onInit: $e');
      }
      // Still initialize answers even if services fail
      answers = List<RxInt>.generate(statements.length, (_) => 0.obs);
      // Ensure loading state is false
      isLoadingData.value = false;
    }
  }

  void selectTrue(int index) => answers[index].value = 2;

  void selectFalse(int index) => answers[index].value = 1;

  Future<void> refreshScreeningData() async {
    await _fetchExistingScreeningData();
  }

  // Callback function to be set by the view
  Function(String, bool)? onShowResult;

  void showResultBottomSheet(String risk, bool isRisk) {
    onShowResult?.call(risk, isRisk);
  }

  Future<void> _fetchExistingScreeningData() async {
    try {
      // Check if services are properly initialized
      if (!Get.isRegistered<AuthService>() ||
          !Get.isRegistered<ScreeningService>()) {
        if (kDebugMode) {
          print('Services not yet registered, skipping data fetch');
        }
        return;
      }

      final currentUser = _authService.currentUser;
      if (currentUser == null) return;

      isLoadingData.value = true;

      final response = await _screeningService.getScreeningList(
        userId: currentUser.id,
        page: 1,
        pageSize: 1,
      );

      if (kDebugMode) {
        print('Fetch screening result: ${response.success}');
        print('Fetch screening message: ${response.message}');
      }

      if (response.success && response.data != null) {
        final listResponse = response.data!;

        if (listResponse.success && listResponse.data.isNotEmpty) {
          // Data exists, set to edit mode and populate form
          final screeningData = listResponse.data.first;
          existingScreening.value = screeningData;
          isEditMode.value = true;
          _populateFormWithExistingData(screeningData);
        } else {
          // No data exists, keep in create mode
          isEditMode.value = false;
          existingScreening.value = null;
        }
      } else {
        // Handle error case
        if (kDebugMode) {
          print('Error fetching screening data: ${response.message}');
        }
        isEditMode.value = false;
        existingScreening.value = null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception in _fetchExistingScreeningData: $e');
      }
      isEditMode.value = false;
      existingScreening.value = null;
    } finally {
      // Always set loading to false
      isLoadingData.value = false;
    }
  }

  void _populateFormWithExistingData(ScreeningItemWithResponden data) {
    // Convert to unified model for easier handling
    final screeningData = ScreeningDataModel.fromScreeningItem(data);

    // Map existing data to form answers
    answers[0].value = screeningData.umurMenstruasiPertamaDiBawah12 ? 2 : 1;
    answers[1].value = screeningData.belumPernahMelahirkan ? 2 : 1;
    answers[2].value = screeningData.belumPernahMenyusui ? 2 : 1;
    answers[3].value = screeningData.menyusuiKurangDari6 ? 2 : 1;
    answers[4].value = screeningData.melahirkanAnakPertamaDiAtas35 ? 2 : 1;
    answers[5].value = screeningData.menggunakanKb == "PIL" ? 2 : 1;
    answers[6].value = screeningData.menopauseDiAtas50 ? 2 : 1;
    answers[7].value = screeningData.pernahTumorJinak ? 2 : 1;
    answers[8].value = screeningData.riwayatKeluargaKankerPayudara ? 2 : 1;
    answers[9].value = screeningData.consumeAlcohol ? 2 : 1;
    answers[10].value = screeningData.smoking ? 2 : 1;
    answers[11].value = screeningData.obesitas ? 2 : 1;
  }

  void submit() async {
    // 1. Validasi semua pertanyaan sudah dijawab
    final hasUnanswered = answers.any((r) => r.value == 0);
    if (hasUnanswered) {
      _showErrorSnackbar('Harap jawab semua pernyataan sebelum mengirim.');
      return;
    }

    try {
      isLoading.value = true;

      // 2. Validasi user sudah login
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        _showErrorSnackbar('Silakan login terlebih dahulu');
        return;
      }

      // 3. Siapkan data untuk API
      final screeningData = _mapAnswersToApiModel(currentUser.id);

      // 4. Submit data menggunakan service
      final response = await _screeningService.submitScreening(
        data: screeningData,
        existingScreeningId: existingScreening.value?.idSkriningKankerPayudara,
      );

      if (kDebugMode) {
        print('Submit screening result: ${response.success}');
        print('Submit screening message: ${response.message}');
      }

      // 5. Handle response
      if (response.success) {
        // 6. Jika dari jadwal, tampilkan dialog abnormalitas
        if (isFromSchedule) {
          AppDialog.showAbnormalityDialog(
            onResult: (result) {
              // Save result to active schedule
              _saveResultToSchedule(result);
            },
          );
          return;
        }

        await _fetchExistingScreeningData();

        final anyYes = answers.any((r) => r.value == 2);
        final risk =
            anyYes
                ? 'Anda Berisiko Terkena Kanker Payudara'
                : 'Anda Tidak Berisiko Terkena Kanker Payudara';

        final isRisk = anyYes;
        showResultBottomSheet(risk, isRisk);

        isEditMode.value = true;
      } else {
        _showErrorSnackbar(response.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception in submit: $e');
      }
      _showErrorSnackbar(
        'Terjadi kesalahan saat mengirim data: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper method to map answers to API model
  ScreeningDataModel _mapAnswersToApiModel(String userId) {
    return ScreeningDataModel(
      respondenId: userId,
      umurMenstruasiPertamaDiBawah12: answers[0].value == 2,
      belumPernahMelahirkan: answers[1].value == 2,
      belumPernahMenyusui: answers[2].value == 2,
      menyusuiKurangDari6: answers[3].value == 2,
      melahirkanAnakPertamaDiAtas35: answers[4].value == 2,
      menggunakanKb: answers[5].value == 2 ? "PIL" : "Tidak",
      menopauseDiAtas50: answers[6].value == 2,
      pernahTumorJinak: answers[7].value == 2,
      riwayatKeluargaKankerPayudara: answers[8].value == 2,
      consumeAlcohol: answers[9].value == 2,
      smoking: answers[10].value == 2,
      obesitas: answers[11].value == 2,
    );
  }

  /// Helper method to show error snackbar
  void _showErrorSnackbar(String message) {
    AppSnackbar.error(title: 'Error', message: message);
  }

  /// Save SADARI result to active schedule
  void _saveResultToSchedule(String result) {
    try {
      final scheduleService = Get.find<ScheduleService>();
      final activeSchedule = scheduleService.activeSchedule;

      if (activeSchedule != null) {
        scheduleService.updateScheduleResult(activeSchedule.id, result);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving result to schedule: $e');
      }
    }
  }
}
