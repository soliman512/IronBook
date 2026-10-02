import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ironbook/core/constants/app_colors.dart';

abstract final class AppTextStyles {
  static final TextStyle displayHero = GoogleFonts.bricolageGrotesque(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );
  static final TextStyle screenTitle = GoogleFonts.bricolageGrotesque(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );
  static final TextStyle authHeader = GoogleFonts.bricolageGrotesque(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );
  static final TextStyle planCardTitle = GoogleFonts.bricolageGrotesque(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
  static final TextStyle bodyText = GoogleFonts.bricolageGrotesque(
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static final TextStyle bodyMedium = GoogleFonts.bricolageGrotesque(
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
  static final TextStyle specialBodyMedium = GoogleFonts.libertinusSerif(
    fontSize: 14,
    color: AppColors.primary,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle buttonText = GoogleFonts.bricolageGrotesque(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle monoGymId = GoogleFonts.jetBrainsMono(
    fontSize: 38,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.76,
    color: AppColors.primary,
  );
  static final TextStyle monoLabel = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
  );
}
