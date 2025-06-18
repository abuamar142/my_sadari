import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sadari/app/styles/app_colors.dart';
import 'package:my_sadari/app/styles/app_dimension.dart';
import 'package:my_sadari/app/styles/app_text_style.dart';

import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue2,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Jadwal SADARI', style: AppTextStyle.headingMedium2),
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
          SizedBox(height: AppDimensions.paddingLarge),
          _counting(context),
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
            "Pemeriksaan payudara sendiri dilakukan 10 hari setelah menstruasi hari pertama.",
            textAlign: TextAlign.justify,
            style: TextStyle(color: AppColors.pink),
          ),
        ],
      ),
    );
  }

  Widget _counting(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Tanggal awal setelah menstruasi', style: AppTextStyle.bodyMedium1),
          SizedBox(height: AppDimensions.paddingMedium),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Obx(
                    () => Text(controller.formattedDate, style: AppTextStyle.bodyLarge1),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: controller.selectDate.value,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2100),
                    locale: const Locale('id', 'ID'),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.blue1,
                            onPrimary: AppColors.white,
                            onSurface: AppColors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      controller.selectDate.value = value;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple1),
                child: Text('Pilih Tanggal', style: AppTextStyle.bodyMedium2),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          Text('Tanggal periksa SADARI Anda adalah', style: AppTextStyle.bodyMedium1),
          SizedBox(height: AppDimensions.paddingMedium),
          Obx(() => Text(controller.formattedExamDate, style: AppTextStyle.bodyLarge1)),
        ],
      ),
    );
  }
}
