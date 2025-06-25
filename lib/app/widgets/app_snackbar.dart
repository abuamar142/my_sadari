import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/app_colors.dart';
import '../styles/app_text_style.dart';

class AppSnackbar {
  /// Show success snackbar
  static void success({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool isDismissible = true,
    VoidCallback? onTap,
  }) {
    _show(
      title: title,
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: AppColors.teal1,
      iconColor: AppColors.white,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 3),
      position: position,
      isDismissible: isDismissible,
      onTap: onTap,
    );
  }

  /// Show error snackbar
  static void error({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool isDismissible = true,
    VoidCallback? onTap,
  }) {
    _show(
      title: title,
      message: message,
      icon: Icons.error_rounded,
      backgroundColor: AppColors.red,
      iconColor: AppColors.white,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 4),
      position: position,
      isDismissible: isDismissible,
      onTap: onTap,
    );
  }

  /// Show warning snackbar
  static void warning({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool isDismissible = true,
    VoidCallback? onTap,
  }) {
    _show(
      title: title,
      message: message,
      icon: Icons.warning_rounded,
      backgroundColor: AppColors.orange,
      iconColor: AppColors.white,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 3),
      position: position,
      isDismissible: isDismissible,
      onTap: onTap,
    );
  }

  /// Show info snackbar
  static void info({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool isDismissible = true,
    VoidCallback? onTap,
  }) {
    _show(
      title: title,
      message: message,
      icon: Icons.info_rounded,
      backgroundColor: AppColors.blue1,
      iconColor: AppColors.white,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 3),
      position: position,
      isDismissible: isDismissible,
      onTap: onTap,
    );
  }

  /// Show loading snackbar
  static void loading({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool isDismissible = false,
  }) {
    _show(
      title: title,
      message: message,
      icon: Icons.hourglass_empty_rounded,
      backgroundColor: AppColors.purple1,
      iconColor: AppColors.white,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 5),
      position: position,
      isDismissible: isDismissible,
      showProgressIndicator: true,
    );
  }

  /// Show custom snackbar
  static void custom({
    required String title,
    required String message,
    required IconData icon,
    required Color backgroundColor,
    Color? iconColor,
    Color? textColor,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool isDismissible = true,
    bool showProgressIndicator = false,
    VoidCallback? onTap,
  }) {
    _show(
      title: title,
      message: message,
      icon: icon,
      backgroundColor: backgroundColor,
      iconColor: iconColor ?? AppColors.white,
      textColor: textColor ?? AppColors.white,
      duration: duration ?? const Duration(seconds: 3),
      position: position,
      isDismissible: isDismissible,
      showProgressIndicator: showProgressIndicator,
      onTap: onTap,
    );
  }

  /// Private method to show snackbar
  static void _show({
    required String title,
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
    required Duration duration,
    required SnackPosition position,
    required bool isDismissible,
    bool showProgressIndicator = false,
    VoidCallback? onTap,
  }) {
    // Close current snackbar if open
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.horizontal,
      animationDuration: const Duration(milliseconds: 500),
      onTap: onTap != null ? (_) => onTap() : null,
      titleText: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.headingSmall1.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (showProgressIndicator)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              ),
            ),
        ],
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 44),
        child: Text(
          message,
          style: AppTextStyle.bodyMedium1.copyWith(
            color: textColor.withValues(alpha: 0.9),
            height: 1.4,
          ),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: backgroundColor.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Close current snackbar
  static void close() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }

  /// Show action snackbar with buttons
  static void action({
    required String title,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    String? cancelLabel,
    VoidCallback? onCancel,
    IconData? icon,
    Color? backgroundColor,
    Duration? duration,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    _show(
      title: title,
      message: message,
      icon: icon ?? Icons.info_rounded,
      backgroundColor: backgroundColor ?? AppColors.purple1,
      iconColor: AppColors.white,
      textColor: AppColors.white,
      duration: duration ?? const Duration(seconds: 5),
      position: position,
      isDismissible: true,
    );

    // Show actions using GetX mainButton and other features
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor ?? AppColors.purple1,
      colorText: AppColors.white,
      duration: duration ?? const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      isDismissible: true,
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
          onAction();
        },
        child: Text(
          actionLabel,
          style: AppTextStyle.buttonText1.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      titleText: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon ?? Icons.info_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.headingSmall1.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 44),
        child: Text(
          message,
          style: AppTextStyle.bodyMedium1.copyWith(
            color: AppColors.white.withValues(alpha: 0.9),
            height: 1.4,
          ),
        ),
      ),
      boxShadows: [
        BoxShadow(
          color: (backgroundColor ?? AppColors.purple1).withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
