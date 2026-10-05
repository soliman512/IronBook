import 'package:flutter/material.dart';

import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_radius.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.title,
    required this.controller,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
  });

  final String? title;
  final TextEditingController controller;

  final String? hintText;
  final String? Function(String?)? validator;

  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  final bool enabled;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 12),
          ),

        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onTap: onTap,
          enabled: enabled,
          readOnly: readOnly,
          style: TextTheme.of(context).bodyMedium!,
          maxLength: maxLength,
          decoration: InputDecoration(
            errorStyle: TextTheme.of(context).labelSmall!
                .copyWith(fontSize: 10, color: AppColors.danger),
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.white,

            contentPadding: const .all(16),
            hintStyle: TextTheme.of(context).bodyMedium!
                .copyWith(color: AppColors.secondary, fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(color: AppColors.danger, width: 1),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(color: AppColors.danger, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
