import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../models/screening_model.dart';

class Statement {
  final String text;
  final bool isMajor;

  Statement(this.text, this.isMajor);
}

class ScreeningController extends GetxController {
  final storage = GetStorage();

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
    answers = List<RxInt>.generate(statements.length, (_) => 0.obs);
  }

  void selectTrue(int index) => answers[index].value = 2;

  void selectFalse(int index) => answers[index].value = 1;

  void submit() {
    // 1. Pastikan tidak ada yang belum dijawab
    final hasUnanswered = answers.any((r) => r.value == 0);
    if (hasUnanswered) {
      Get.snackbar(
        'Peringatan',
        'Harap jawab semua pernyataan sebelum submit.',
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
      );
      return;
    }

    // 2. Tentukan risiko berdasarkan jawaban
    final anyYes = answers.any((r) => r.value == 2);
    final risk =
        anyYes
            ? 'Anda Berisiko Terkena Kanker Payudara'
            : 'Anda Tidak Berisiko Terkena Kanker Payudara';

    // 3. Buat objek result dan simpan ke GetStorage
    final result = ScreeningResult(
      timestamp: DateTime.now(),
      riskLevel: risk,
      answers: answers.map((r) => r.value).toList(),
    );

    final List stored = storage.read<List>('riwayat') ?? <dynamic>[];
    stored.add(result.toJson());
    storage.write('riwayat', stored);

    // 4. Tampilkan dialog hasil + navigasi ke Riwayat
    final isRisk = anyYes;
    Get.defaultDialog(
      title: 'Hasil Skrining',
      content: Column(
        children: [
          Icon(Icons.info, color: isRisk ? AppColors.red : AppColors.teal1, size: 48),
          SizedBox(height: 12),
          Text(
            risk,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isRisk ? AppColors.red : AppColors.teal1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      textConfirm: 'Lihat Riwayat',
      confirmTextColor: AppColors.white,
      onConfirm: () {
        Get.back();
        Get.toNamed(Routes.history);
      },
    );
  }
}
