import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/styles/app_colors.dart';
import 'package:my_sadari/app/styles/app_dimension.dart';

import '../controllers/screening_controller.dart';

class ScreeningView extends GetView<ScreeningController> {
  const ScreeningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue2,
      appBar: AppBar(
        title: Text(
          'Skrining Faktor Risiko',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        children: [
          _warning(),
          SizedBox(height: 20),
          _questions(),
          SizedBox(height: 24),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _warning() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.pink),
          SizedBox(height: 8),
          Text(
            textAlign: TextAlign.justify,
            "Untuk mengetahui faktor risiko payudara, berikan tanggapan Anda dengan melakukan checklist pada setiap pernyataan jika sesuai dengan pengalaman Anda.",
            style: TextStyle(color: AppColors.pink),
          ),
        ],
      ),
    );
  }

  Widget questionTile(int index) {
    final stmt = controller.statements[index];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purple1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            stmt.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() {
                final sel = controller.answers[index].value;
                return Row(
                  children: [
                    Checkbox(
                      value: sel == 1,
                      onChanged: (_) => controller.selectFalse(index),
                      activeColor: AppColors.teal1,
                    ),
                    Text('Tidak', style: TextStyle(color: AppColors.white)),
                  ],
                );
              }),
              Obx(() {
                final sel = controller.answers[index].value;
                return Row(
                  children: [
                    Checkbox(
                      value: sel == 2,
                      onChanged: (_) => controller.selectTrue(index),
                      activeColor: AppColors.teal1,
                    ),
                    Text('Ya', style: TextStyle(color: AppColors.white)),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _questions() {
    return Column(
      children: List.generate(controller.statements.length, (i) => questionTile(i)),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple3,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          final hasUnanswered = controller.answers.any((ans) => ans.value == 0);
          if (hasUnanswered) {
            Get.snackbar(
              'Peringatan',
              'Harap jawab semua pernyataan sebelum submit.',
              backgroundColor: AppColors.red,
              colorText: AppColors.white,
            );
            return;
          }
          controller.submit();
        },
        child: Text(
          'Submit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
