import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../controllers/screening_controller.dart';

class ScreeningView extends GetView<ScreeningController> {
  const ScreeningView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the callback when the widget is built
    controller.onShowResult = _showResultBottomSheet;
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background3),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Skrining Faktor Risiko',
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
        body: Center(
          child: Obx(() {
            if (controller.isLoadingData.value) {
              return Container(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
                width: Get.width * 0.95,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusLarge,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.red),
                    SizedBox(height: 16),
                    Text(
                      'Memuat data screening...',
                      style: AppTextStyle.bodyMedium1,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
                width: Get.width * 0.95,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusLarge,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12),
                    _warning(),
                    SizedBox(height: 24),
                    _questions(),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            );
          }),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _warning() {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color:
              controller.isEditMode.value
                  ? AppColors.teal1.withValues(alpha: 0.1)
                  : AppColors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color:
                controller.isEditMode.value
                    ? AppColors.teal1.withValues(alpha: 0.2)
                    : AppColors.red.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  controller.isEditMode.value
                      ? Icons.edit_outlined
                      : Icons.info_outline_rounded,
                  color:
                      controller.isEditMode.value
                          ? AppColors.teal1
                          : AppColors.red,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  controller.isEditMode.value ? 'Mode Edit' : 'Petunjuk',
                  style: AppTextStyle.headingSmall1.copyWith(
                    color:
                        controller.isEditMode.value
                            ? AppColors.teal1
                            : AppColors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              controller.isEditMode.value
                  ? "Anda sedang mengedit data screening yang sudah ada. Ubah jawaban sesuai kebutuhan dan klik tombol 'UBAH' untuk menyimpan perubahan."
                  : "Untuk mengetahui faktor risiko payudara, berikan tanggapan Anda dengan melakukan checklist pada setiap pernyataan jika sesuai dengan pengalaman Anda.",
              textAlign: TextAlign.justify,
              style: AppTextStyle.bodyMedium1.copyWith(
                color:
                    controller.isEditMode.value
                        ? AppColors.teal1
                        : AppColors.red,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget questionTile(int index) {
    final stmt = controller.statements[index];

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingLarge),
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.blue2.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.blue2.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            stmt.text,
            style: AppTextStyle.bodyLarge1.copyWith(
              color: AppColors.black,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  final sel = controller.answers[index].value;
                  return InkWell(
                    onTap: () => controller.selectFalse(index),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: sel == 1 ? AppColors.teal1 : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSmall,
                        ),
                        border: Border.all(
                          color: sel == 1 ? AppColors.teal1 : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            sel == 1
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: sel == 1 ? AppColors.white : Colors.grey,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Tidak',
                            style: AppTextStyle.bodyMedium1.copyWith(
                              color:
                                  sel == 1 ? AppColors.white : AppColors.black,
                              fontWeight:
                                  sel == 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Obx(() {
                  final sel = controller.answers[index].value;
                  return InkWell(
                    onTap: () => controller.selectTrue(index),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: sel == 2 ? AppColors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSmall,
                        ),
                        border: Border.all(
                          color: sel == 2 ? AppColors.red : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            sel == 2
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: sel == 2 ? AppColors.white : Colors.grey,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Ya',
                            style: AppTextStyle.bodyMedium1.copyWith(
                              color:
                                  sel == 2 ? AppColors.white : AppColors.black,
                              fontWeight:
                                  sel == 2
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _questions() {
    return Column(
      children: List.generate(
        controller.statements.length,
        (i) => questionTile(i),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingLarge),
          child: _submitButton(),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.teal1,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            elevation: 2,
          ),
          onPressed:
              controller.isLoading.value
                  ? null
                  : () {
                    final hasUnanswered = controller.answers.any(
                      (ans) => ans.value == 0,
                    );
                    if (hasUnanswered) {
                      Get.snackbar(
                        'Peringatan',
                        'Harap jawab semua pernyataan sebelum submit.',
                        backgroundColor: AppColors.red,
                        colorText: AppColors.white,
                        snackPosition: SnackPosition.TOP,
                        margin: EdgeInsets.all(AppDimensions.paddingMedium),
                        borderRadius: AppDimensions.radiusSmall,
                      );
                      return;
                    }
                    controller.submit();
                  },
          child:
              controller.isLoading.value
                  ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                  : Text(
                    controller.submitButtonText,
                    style: AppTextStyle.buttonText1,
                  ),
        ),
      ),
    );
  }

  void _showResultBottomSheet(String risk, bool isRisk) {
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
          children: [
            Icon(
              Icons.info,
              color: isRisk ? AppColors.red : AppColors.teal1,
              size: 48,
            ),
            SizedBox(height: 12),
            Text(
              risk,
              style: AppTextStyle.headingMedium1.copyWith(
                color: isRisk ? AppColors.red : AppColors.teal1,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              controller.isEditMode.value
                  ? 'Data berhasil diperbarui'
                  : 'Data berhasil disimpan',
              style: AppTextStyle.bodyMedium1.copyWith(color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      'Kembali',
                      style: AppTextStyle.bodyLarge1.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
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
                    onPressed: () {
                      Get.back();
                      Get.toNamed(Routes.history);
                    },
                    child: Text(
                      'Lihat Riwayat',
                      style: AppTextStyle.buttonText1,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(Get.context!).padding.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
