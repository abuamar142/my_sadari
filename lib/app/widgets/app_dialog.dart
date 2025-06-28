import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../styles/app_colors.dart';
import '../styles/app_dimension.dart';
import '../styles/app_text_style.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final IconData headerIcon;
  final Color headerColor;
  final Color headerSecondaryColor;
  final String content;
  final Widget? infoBox;
  final List<DialogAction> actions;
  final bool barrierDismissible;
  final Widget? customContent;

  const AppDialog({
    super.key,
    required this.title,
    required this.headerIcon,
    required this.headerColor,
    required this.headerSecondaryColor,
    required this.content,
    this.infoBox,
    required this.actions,
    this.barrierDismissible = false,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      insetPadding: EdgeInsets.all(16),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          color: AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildHeader(), _buildContent(), _buildActions()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            headerColor.withValues(alpha: 0.1),
            headerSecondaryColor.withValues(alpha: 0.05),
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
                colors: [headerColor, headerSecondaryColor],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: headerColor.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(headerIcon, color: AppColors.white, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.headingMedium1.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (customContent != null) ...[
            customContent!,
          ] else ...[
            Text(
              content,
              textAlign: TextAlign.justify,
              style: AppTextStyle.bodyMedium1.copyWith(
                color: AppColors.black,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (infoBox != null) ...[SizedBox(height: 16), infoBox!],
          ],
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      child:
          actions.length == 1
              ? SizedBox(width: double.infinity, child: actions.first.build())
              : Row(
                children: [
                  for (int i = 0; i < actions.length; i++) ...[
                    Expanded(child: actions[i].build()),
                    if (i < actions.length - 1) SizedBox(width: 12),
                  ],
                ],
              ),
    );
  }

  static void show({
    required String title,
    required IconData headerIcon,
    required Color headerColor,
    required Color headerSecondaryColor,
    required String content,
    Widget? infoBox,
    required List<DialogAction> actions,
    bool barrierDismissible = false,
    Widget? customContent,
  }) {
    Get.dialog(
      AppDialog(
        title: title,
        headerIcon: headerIcon,
        headerColor: headerColor,
        headerSecondaryColor: headerSecondaryColor,
        content: content,
        infoBox: infoBox,
        actions: actions,
        barrierDismissible: barrierDismissible,
        customContent: customContent,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static void showAbnormalityDialog({Function(String)? onResult}) {
    AppDialog.show(
      title: 'Pertanyaan Wajib',
      headerIcon: Icons.help_outline,
      headerColor: AppColors.orange,
      headerSecondaryColor: AppColors.orange.withValues(alpha: 0.8),
      content:
          'Apakah setelah melakukan pemeriksaan SADARI ditemukan abnormalitas pada payudara?',
      infoBox: InfoBox(
        text: 'Pertanyaan ini wajib dijawab',
        icon: Icons.info_outline,
        color: AppColors.orange,
      ),
      actions: [
        DialogAction(
          label: 'Tidak',
          type: DialogActionType.secondary,
          color: AppColors.teal1,
          onPressed: () {
            Get.back();
            onResult?.call('normal');
            showNormalResultDialog();
          },
        ),
        DialogAction(
          label: 'Ya',
          type: DialogActionType.primary,
          color: AppColors.red,
          onPressed: () {
            Get.back();
            onResult?.call('abnormal');
            showAbnormalityWarning();
          },
        ),
      ],
      barrierDismissible: false,
    );
  }

  static void showAbnormalityWarning() {
    AppDialog.show(
      title: 'Peringatan Penting',
      headerIcon: Icons.warning_rounded,
      headerColor: AppColors.red,
      headerSecondaryColor: AppColors.pink,
      content: '',
      customContent: WarningContent(
        message:
            'Ditemukan adanya ketidaknormalan pada payudara. Segera periksakan ke pelayanan kesehatan terdekat.',
        actionText: 'Hubungi dokter atau puskesmas terdekat segera',
      ),
      actions: [
        DialogAction(
          label: 'Tutup',
          type: DialogActionType.primary,
          color: AppColors.red,
          icon: Icons.home,
          onPressed: () {
            Get.back();
            Get.offAllNamed(Routes.home);
          },
        ),
      ],
      barrierDismissible: false,
    );
  }

  static void showNormalResultDialog() {
    AppDialog.show(
      title: 'Hasil Pemeriksaan',
      headerIcon: Icons.check_circle_rounded,
      headerColor: AppColors.teal1,
      headerSecondaryColor: AppColors.teal2,
      content: 'Tidak Ditemukan Adanya Ketidaknormalan Pada Payudara.',
      infoBox: InfoBox(
        text: 'Tetap lakukan pemeriksaan SADARI secara rutin setiap bulan',
        icon: Icons.info_outline,
        color: AppColors.teal1,
      ),
      actions: [
        DialogAction(
          label: 'Tutup',
          type: DialogActionType.primary,
          color: AppColors.teal1,
          icon: Icons.home,
          onPressed: () {
            Get.back();
            Get.offAllNamed(Routes.home);
          },
        ),
      ],
      barrierDismissible: false,
    );
  }
}

class DialogAction {
  final String label;
  final VoidCallback onPressed;
  final DialogActionType type;
  final Color? color;
  final IconData? icon;

  const DialogAction({
    required this.label,
    required this.onPressed,
    required this.type,
    this.color,
    this.icon,
  });

  Widget build() {
    switch (type) {
      case DialogActionType.primary:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon:
              icon != null
                  ? Icon(icon, color: AppColors.white, size: 20)
                  : SizedBox.shrink(),
          label: Text(
            label,
            style: AppTextStyle.buttonText1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? AppColors.teal1,
            padding: EdgeInsets.symmetric(vertical: 14),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadowColor: (color ?? AppColors.teal1).withValues(alpha: 0.3),
          ),
        );
      case DialogActionType.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color ?? Colors.grey[400]!),
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            label,
            style: AppTextStyle.buttonText1.copyWith(
              color: color ?? Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }
}

enum DialogActionType { primary, secondary }

class InfoBox extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const InfoBox({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.bodySmall1.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WarningContent extends StatelessWidget {
  final String message;
  final String actionText;

  const WarningContent({
    super.key,
    required this.message,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Icon(Icons.local_hospital_rounded, color: AppColors.red, size: 48),
          SizedBox(height: 16),
          Text(
            message,
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
              border: Border.all(color: AppColors.red.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.phone, color: AppColors.red, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    actionText,
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
    );
  }
}
