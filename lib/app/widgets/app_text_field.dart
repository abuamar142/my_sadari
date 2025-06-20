import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/app_colors.dart';
import '../styles/app_dimension.dart';
import '../styles/app_text_style.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final VoidCallback? onTapOutside;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onTapOutside,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      textInputAction: textInputAction,
      style: AppTextStyle.bodyMedium1,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.caption,
        filled: true,
        fillColor:
            enabled
                ? Colors.grey.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: AppColors.pink, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: Get.theme.colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: Get.theme.colorScheme.error, width: 1),
        ),
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onTapOutside:
          onTapOutside != null
              ? (_) => onTapOutside!()
              : (_) => FocusScope.of(context).unfocus(),
    );
  }
}

class AppPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final RxBool hidePassword;
  final VoidCallback onToggleVisibility;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;

  const AppPasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.hidePassword,
    required this.onToggleVisibility,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppTextField(
        controller: controller,
        hintText: hintText,
        prefixIcon: Icons.lock,
        obscureText: hidePassword.value,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            hidePassword.value ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
