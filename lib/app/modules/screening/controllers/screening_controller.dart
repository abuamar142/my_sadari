import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/models/api_response_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../models/screening_api_model.dart';
import '../models/screening_list_model.dart';
import '../models/screening_model.dart';

class Statement {
  final String text;
  final bool isMajor;

  Statement(this.text, this.isMajor);
}

class ScreeningController extends GetxController {
  final storage = GetStorage();
  late final AuthService _authService;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingData = false.obs;
  final RxBool isEditMode = false.obs;
  final Rx<ScreeningItemWithResponden?> existingScreening =
      Rx<ScreeningItemWithResponden?>(null);

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
    _authService = Get.find<AuthService>();
    answers = List<RxInt>.generate(statements.length, (_) => 0.obs);
    _fetchExistingScreeningData();
  }

  void selectTrue(int index) => answers[index].value = 2;

  void selectFalse(int index) => answers[index].value = 1;

  String get submitButtonText => isEditMode.value ? 'UBAH' : 'SIMPAN';
  Future<void> _fetchExistingScreeningData() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    try {
      isLoadingData.value = true;

      final token = storage.read('auth_token');
      final response = await GetConnect().get(
        'https://sadari.sdnusabali.online/api/screening_cancer?page=1&pageSize=1&filter[id_user]=${currentUser.id}',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (kDebugMode) {
        print('Fetch screening response: ${response.statusCode}');
        print('Fetch screening response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final listResponse = ScreeningListResponse.fromJson(response.body);

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
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching existing screening data: $e');
      }
    } finally {
      isLoadingData.value = false;
    }
  }

  void _populateFormWithExistingData(ScreeningItemWithResponden data) {
    // Map existing data to form answers
    answers[0].value = data.umurMenstruasiPertamaDiBawah12 ? 2 : 1;
    answers[1].value = data.belumPernahMelahirkan ? 2 : 1;
    answers[2].value = data.belumPernahMenyusui ? 2 : 1;
    answers[3].value =
        1; // Default to "tidak" for question 3 (menyusui < 6 bulan)
    answers[4].value = data.melahirkanAnakPertamaDiAtas35 ? 2 : 1;
    answers[5].value = data.menggunakanKb == "PIL" ? 2 : 1;
    answers[6].value = data.menopauseDiAtas50 ? 2 : 1;
    answers[7].value = data.pernahTumorJinak ? 2 : 1;
    answers[8].value = data.riwayatKeluargaKankerPayudara ? 2 : 1;
    answers[9].value = (data.consumeAlcohol ?? false) ? 2 : 1;
    answers[10].value = (data.smoking ?? false) ? 2 : 1;
    answers[11].value = (data.obesitas ?? false) ? 2 : 1;
  }

  void submit() async {
    // 1. Pastikan tidak ada yang belum dijawab
    final hasUnanswered = answers.any((r) => r.value == 0);
    if (hasUnanswered) {
      Get.snackbar(
        'Peringatan',
        'Harap jawab semua pernyataan sebelum submit.',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 2. Siapkan data untuk API
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        Get.snackbar(
          'Error',
          'Silakan login terlebih dahulu',
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
        return;
      }

      // Mapping answers to screening data based on statement indices
      final screeningData = ScreeningApiModel(
        respondenId: currentUser.id,
        umurMenstruasiPertamaDiBawah12: answers[0].value == 2,
        belumPernahMelahirkan: answers[1].value == 2,
        belumPernahMenyusui: answers[2].value == 2,
        melahirkanAnakPertamaDiAtas35: answers[4].value == 2,
        menggunakanKb: answers[5].value == 2 ? "PIL" : "Tidak",
        menopauseDiAtas50: answers[6].value == 2,
        pernahTumorJinak: answers[7].value == 2,
        riwayatKeluargaKankerPayudara: answers[8].value == 2,
        consumeAlcohol: answers[9].value == 2,
        smoking: answers[10].value == 2,
        obesitas: answers[11].value == 2,
      );

      // 3. Kirim data ke API
      final token = storage.read('auth_token');
      Response response;

      if (isEditMode.value && existingScreening.value != null) {
        // Update existing data using PUT method
        response = await GetConnect().put(
          'https://sadari.sdnusabali.online/api/screening_cancer/${existingScreening.value!.idSkriningKankerPayudara}',
          screeningData.toJson(),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      } else {
        // Create new data using POST method
        response = await GetConnect().post(
          'https://sadari.sdnusabali.online/api/screening_cancer',
          screeningData.toJson(),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      }

      if (kDebugMode) {
        print('Screening response: ${response.statusCode}');
        print('Screening response body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final apiResponse = ApiResponseModel<ScreeningApiModel>.fromJson(
          response.body,
          (data) => ScreeningApiModel.fromJson(data),
        );

        if (apiResponse.success) {
          // 4. Simpan juga ke local storage untuk backup
          final anyYes = answers.any((r) => r.value == 2);
          final risk =
              anyYes
                  ? 'Anda Berisiko Terkena Kanker Payudara'
                  : 'Anda Tidak Berisiko Terkena Kanker Payudara';

          final result = ScreeningResult(
            timestamp: DateTime.now(),
            riskLevel: risk,
            answers: answers.map((r) => r.value).toList(),
          );

          final List stored = storage.read<List>('riwayat') ?? <dynamic>[];
          stored.add(result.toJson());
          storage.write('riwayat', stored);

          // 5. Tampilkan dialog hasil + navigasi ke Riwayat
          final isRisk = anyYes;
          Get.bottomSheet(
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info,
                    color: isRisk ? AppColors.red : AppColors.teal1,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    risk,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isRisk ? AppColors.red : AppColors.teal1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isEditMode.value
                        ? 'Data berhasil diperbarui'
                        : 'Data berhasil disimpan',
                    style: TextStyle(fontSize: 14, color: AppColors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            'Kembali',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pink,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            Get.toNamed(Routes.history);
                          },
                          child: const Text(
                            'Lihat Riwayat',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(Get.context!).padding.bottom),
                ],
              ),
            ),
          );
        } else {
          Get.snackbar(
            'Error',
            apiResponse.message,
            backgroundColor: AppColors.red,
            colorText: AppColors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          isEditMode.value
              ? 'Gagal memperbarui data screening: ${response.statusText}'
              : 'Gagal mengirim data screening: ${response.statusText}',
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting screening: $e');
      }
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengirim data: ${e.toString()}',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
