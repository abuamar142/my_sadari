import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../../screening/models/screening_list_model.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background3),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Riwayat Skrining',
            style: AppTextStyle.headingLarge2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: AppColors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Obx(() {
          if (controller.isLoading.value &&
              controller.screeningHistory.isEmpty) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                margin: EdgeInsets.all(AppDimensions.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusLarge,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.teal1),
                    SizedBox(height: 16),
                    Text(
                      'Memuat riwayat screening...',
                      style: AppTextStyle.bodyMedium1,
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.screeningHistory.isEmpty) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                margin: EdgeInsets.all(AppDimensions.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusLarge,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada riwayat screening',
                      style: AppTextStyle.headingMedium1.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Lakukan screening pertama untuk melihat riwayat',
                      style: AppTextStyle.bodyMedium1.copyWith(
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal1,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMedium,
                          ),
                        ),
                      ),
                      onPressed: () => Get.toNamed(Routes.screening),
                      child: Text(
                        'Mulai Screening',
                        style: AppTextStyle.buttonText1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshHistory,
            color: AppColors.teal1,
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingLarge),
              itemCount:
                  controller.screeningHistory.length +
                  (controller.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.screeningHistory.length) {
                  // Load more indicator
                  return Container(
                    padding: EdgeInsets.all(AppDimensions.paddingMedium),
                    child: Center(
                      child: Obx(() {
                        if (controller.isLoadingMore.value) {
                          return CircularProgressIndicator(
                            color: AppColors.teal1,
                            strokeWidth: 2,
                          );
                        } else {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.teal1,
                              side: BorderSide(color: AppColors.teal1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium,
                                ),
                              ),
                            ),
                            onPressed: controller.loadMoreHistory,
                            child: Text('Muat Lebih Banyak'),
                          );
                        }
                      }),
                    ),
                  );
                }

                final item = controller.screeningHistory[index];
                final riskLevel = controller.getRiskLevel(item);
                final isRisk = !riskLevel.contains('Tidak Berisiko');

                return Container(
                  margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusLarge,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusLarge,
                    ),
                    onTap:
                        () => _showDetailBottomSheet(item, riskLevel, isRisk),
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (isRisk
                                          ? AppColors.red
                                          : AppColors.teal1)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusSmall,
                                  ),
                                ),
                                child: Icon(
                                  isRisk ? Icons.warning : Icons.check_circle,
                                  color:
                                      isRisk ? AppColors.red : AppColors.teal1,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      riskLevel,
                                      style: AppTextStyle.bodyLarge1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isRisk
                                                ? AppColors.red
                                                : AppColors.teal1,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      DateFormat(
                                        'dd MMM yyyy, HH:mm',
                                        'id_ID',
                                      ).format(item.createdAt.toLocal()),
                                      style: AppTextStyle.bodySmall1.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _showDetailBottomSheet(
    ScreeningItemWithResponden item,
    String riskLevel,
    bool isRisk,
  ) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusLarge),
            topRight: Radius.circular(AppDimensions.radiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isRisk ? Icons.warning : Icons.check_circle,
                  color: isRisk ? AppColors.red : AppColors.teal1,
                  size: 32,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    riskLevel,
                    style: AppTextStyle.headingMedium1.copyWith(
                      color: isRisk ? AppColors.red : AppColors.teal1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Detail Screening',
              style: AppTextStyle.headingSmall1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tanggal: ${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(item.createdAt.toLocal())}',
              style: AppTextStyle.bodyMedium1,
            ),
            if (item.updatedAt != item.createdAt)
              Text(
                'Diperbarui: ${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(item.updatedAt)}',
                style: AppTextStyle.bodyMedium1,
              ),
            SizedBox(height: 16),
            Text(
              'Jawaban Skrining:',
              style: AppTextStyle.headingSmall1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildAnswerRow(
              'Usia menstruasi pertama dibawah 12 tahun',
              item.umurMenstruasiPertamaDiBawah12,
            ),
            _buildAnswerRow(
              'Belum pernah melahirkan anak',
              item.belumPernahMelahirkan,
            ),
            _buildAnswerRow(
              'Belum pernah menyusui anak',
              item.belumPernahMenyusui,
            ),
            _buildAnswerRow(
              'Menyusui kurang dari 6 bulan',
              item.menyusuiKurangDari6,
            ),
            _buildAnswerRow(
              'Melahirkan anak pertama diatas usia 35 tahun',
              item.melahirkanAnakPertamaDiAtas35,
            ),
            _buildAnswerRow(
              'Menggunakan KB PIL/Suntik',
              item.menggunakanKb == "PIL",
            ),
            _buildAnswerRow(
              'Menopause diusia lebih dari 50 tahun',
              item.menopauseDiAtas50,
            ),
            _buildAnswerRow(
              'Pernah menderita tumor jinak payudara',
              item.pernahTumorJinak,
            ),
            _buildAnswerRow(
              'Riwayat keluarga dengan kanker payudara',
              item.riwayatKeluargaKankerPayudara,
            ),
            _buildAnswerRow(
              'Mengkonsumsi alkohol',
              item.consumeAlcohol ?? false,
            ),
            _buildAnswerRow('Merokok', item.smoking ?? false),
            _buildAnswerRow('Obesitas', item.obesitas ?? false),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRisk ? AppColors.red : AppColors.teal1,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text('Tutup', style: AppTextStyle.buttonText1),
              ),
            ),
            SizedBox(height: MediaQuery.of(Get.context!).padding.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildAnswerRow(String question, bool answer) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            answer ? Icons.check : Icons.close,
            color: answer ? AppColors.red : AppColors.teal1,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              question,
              style: AppTextStyle.bodySmall1.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            answer ? 'Ya' : 'Tidak',
            style: AppTextStyle.bodySmall1.copyWith(
              fontWeight: FontWeight.bold,
              color: answer ? AppColors.red : AppColors.teal1,
            ),
          ),
        ],
      ),
    );
  }
}
