import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/models/api_response_model.dart';
import '../../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../models/screening_api_model.dart';
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
  }

  void selectTrue(int index) => answers[index].value = 2;

  void selectFalse(int index) => answers[index].value = 1;
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
        menggunakanKb: answers[5].value == 2 ? "PIL" : "TIDAK",
        menopauseDiAtas50: answers[6].value == 2,
        pernahTumorJinak: answers[7].value == 2,
        riwayatKeluargaKankerPayudara: answers[8].value == 2,
        consumeAlcohol: answers[9].value == 2,
        smoking: answers[10].value == 2,
        obesitas: answers[11].value == 2,
      );

      // 3. Kirim data ke API
      final token = storage.read('auth_token');
      final response = await GetConnect().post(
        'https://sadari.sdnusabali.online/api/screening_cancer',
        screeningData.toJson(),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

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
          Get.defaultDialog(
            title: 'Hasil Skrining',
            content: Column(
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
                  'Data berhasil disimpan ke server',
                  style: TextStyle(fontSize: 14, color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            textConfirm: 'Lihat Riwayat',
            confirmTextColor: AppColors.white,
            buttonColor: AppColors.pink,
            onConfirm: () {
              Get.back();
              Get.toNamed(Routes.history);
            },
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
          'Gagal mengirim data screening: ${response.statusText}',
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
