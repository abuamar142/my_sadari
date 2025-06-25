import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/step_model.dart';
import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/app_dimension.dart';
import '../../../styles/app_text_style.dart';
import '../../../widgets/app_card_info.dart';
import '../controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.background5),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Cara Pemeriksaan Sadari',
            style: AppTextStyle.headingLarge2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(result: false),
            icon: Icon(Icons.arrow_back, color: AppColors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    try {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCardInfo(
                title: 'Tutorial Sadari',
                subtitle:
                    'Pelajari cara melakukan pemeriksaan payudara sendiri dengan benar',
                color: AppColors.orange,
                icon: Icons.health_and_safety_outlined,
              ),
              SizedBox(height: 24),
              _buildStepsSection(),
              _buildWarningSection(),
              if (controller.isFromSchedule) ...[
                SizedBox(height: 24),
                _buildCompletionSection(),
              ],
              SizedBox(height: 16),
            ],
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error in TutorialView build: $e');
      }
      return Center(
        child: Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Terjadi kesalahan saat memuat tutorial',
                style: AppTextStyle.headingMedium1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...controller.tutorialSteps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            child: _buildStepCard(stepNumber: index + 1, step: step),
          );
        }),
      ],
    );
  }

  Widget _buildWarningSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.red.withValues(alpha: 0.1),
            AppColors.pink.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: AppColors.red.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.red, AppColors.pink],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Peringatan Penting',
                  style: AppTextStyle.headingSmall1.copyWith(
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.red.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Text(
              "JIKA MENEMUKAN BENJOLAN ATAU PERBEDAAN PADA PAYUDARA YANG MEMBUAT ANDA RESAH, SEGERA KONSULTASIKAN KEPADA TENAGA KESEHATAN DI PUSKESMAS SETEMPAT.",
              textAlign: TextAlign.justify,
              style: AppTextStyle.bodyMedium1.copyWith(
                color: AppColors.red,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({required int stepNumber, required StepModel step}) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: step.color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [step.color, step.color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: step.color.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString(),
                    style: AppTextStyle.bodyLarge1.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  step.title,
                  style: AppTextStyle.headingSmall1.copyWith(
                    color: step.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Step Image
          Center(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: step.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(
                  color: step.color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Image.asset(
                step.image,
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Step Description
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              step.description,
              style: AppTextStyle.bodyMedium1.copyWith(
                height: 1.5,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.teal1.withValues(alpha: 0.1),
            AppColors.teal2.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: AppColors.teal1.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal1.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.teal1, AppColors.teal2],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.teal1.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Selesaikan Tutorial',
                  style: AppTextStyle.headingSmall1.copyWith(
                    color: AppColors.teal1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.teal1.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Setelah Anda memahami dan mempraktikkan semua langkah di atas, klik tombol 'Selesai' untuk menandai bahwa Anda telah menyelesaikan pemeriksaan SADARI.",
                  style: AppTextStyle.bodyMedium1.copyWith(
                    color: AppColors.black,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "✓ Pastikan Anda telah melakukan semua langkah pemeriksaan\n✓ Ingat untuk melakukan SADARI secara rutin setiap bulan\n✓ Segera konsultasi jika menemukan kelainan",
                  style: AppTextStyle.bodySmall1.copyWith(
                    color: AppColors.teal1,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _completeTutorial,
                  icon: Icon(
                    Icons.check_circle,
                    color: AppColors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Selesai SADARI',
                    style: AppTextStyle.buttonText1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal1,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                    ),
                    shadowColor: AppColors.teal1.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _completeTutorial() async {
    if (controller.isFromSchedule) {
      await controller.markSadariCompleted();

      _showScreeningOptionsDialog();
    } else {
      _showAbnormalityDialog();
    }
  }

  void _showScreeningOptionsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.teal1.withValues(alpha: 0.1),
                      AppColors.teal2.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusLarge),
                    topRight: Radius.circular(AppDimensions.radiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.teal1, AppColors.teal2],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.teal1.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'SADARI Selesai!',
                        style: AppTextStyle.headingMedium1.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Apakah Anda ingin melakukan update screening faktor risiko?',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyMedium1.copyWith(
                        color: AppColors.black,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.teal1.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.teal1.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.teal1,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ini akan membantu memperbarui profil risiko Anda',
                              style: AppTextStyle.bodySmall1.copyWith(
                                color: AppColors.teal1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          _showAbnormalityDialog();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[400]!),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Tidak',
                          style: AppTextStyle.buttonText1.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.offNamed(
                            Routes.screening,
                            arguments: {'fromSchedule': true},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple1,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadowColor: AppColors.purple1.withValues(alpha: 0.3),
                        ),
                        child: Text(
                          'Ya, Update',
                          style: AppTextStyle.buttonText1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showAbnormalityDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.orange.withValues(alpha: 0.1),
                      AppColors.orange.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusLarge),
                    topRight: Radius.circular(AppDimensions.radiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.orange,
                            AppColors.orange.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.orange.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.help_outline,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Pertanyaan Wajib',
                        style: AppTextStyle.headingMedium1.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apakah setelah melakukan pemeriksaan SADARI ditemukan abnormalitas pada payudara?',
                      textAlign: TextAlign.justify,
                      style: AppTextStyle.bodyMedium1.copyWith(
                        color: AppColors.black,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.orange,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pertanyaan ini wajib dijawab',
                              style: AppTextStyle.bodySmall1.copyWith(
                                color: AppColors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.teal1),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Tidak',
                          style: AppTextStyle.buttonText1.copyWith(
                            color: AppColors.teal1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _showAbnormalityWarning();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadowColor: AppColors.red.withValues(alpha: 0.3),
                        ),
                        child: Text(
                          'Ya',
                          style: AppTextStyle.buttonText1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showAbnormalityWarning() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            color: AppColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.red.withValues(alpha: 0.1),
                      AppColors.pink.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusLarge),
                    topRight: Radius.circular(AppDimensions.radiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.red, AppColors.pink],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.red.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Peringatan Penting',
                        style: AppTextStyle.headingMedium1.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.red.withValues(alpha: 0.1),
                            AppColors.pink.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.red.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_hospital_rounded,
                            color: AppColors.red,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Ditemukan adanya ketidaknormalan pada payudara. Segera periksakan ke pelayanan kesehatan terdekat.',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodyMedium1.copyWith(
                              color: AppColors.red,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.red.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: AppColors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Hubungi dokter atau puskesmas terdekat segera',
                                    style: AppTextStyle.bodySmall1.copyWith(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    icon: Icon(Icons.close, color: AppColors.white, size: 20),
                    label: Text(
                      'Tutup',
                      style: AppTextStyle.buttonText1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadowColor: AppColors.red.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
