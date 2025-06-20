import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../controllers/screening_controller.dart';

class ScreeningView extends GetView<ScreeningController> {
  const ScreeningView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background1),
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
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(AppDimensions.paddingLarge),
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingMedium,
              ),
              width: Get.width * 0.95,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
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
                  _submitButton(),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _warning() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.pink.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.pink.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.pink, size: 24),
              SizedBox(width: 8),
              Text(
                'Petunjuk',
                style: AppTextStyle.headingSmall1.copyWith(
                  color: AppColors.pink,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Untuk mengetahui faktor risiko payudara, berikan tanggapan Anda dengan melakukan checklist pada setiap pernyataan jika sesuai dengan pengalaman Anda.",
            textAlign: TextAlign.justify,
            style: AppTextStyle.bodyMedium1.copyWith(
              color: AppColors.pink,
              height: 1.5,
            ),
          ),
        ],
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
                        color: sel == 2 ? AppColors.pink : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSmall,
                        ),
                        border: Border.all(
                          color: sel == 2 ? AppColors.pink : Colors.grey,
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

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pink,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          elevation: 2,
        ),
        onPressed: () {
          final hasUnanswered = controller.answers.any((ans) => ans.value == 0);
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
        child: Text('SUBMIT', style: AppTextStyle.buttonText1),
      ),
    );
  }
}
