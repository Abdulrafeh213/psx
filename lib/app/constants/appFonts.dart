import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class FontSizes {
  static const double xs = 10.0;
  static const double small = 12.0;
  static const double regular = 14.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

class AppTextStyles {
  static final TextStyle heading1 = GoogleFonts.montserrat(
    fontSize: FontSizes.xxl,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static final TextStyle heading2 = GoogleFonts.montserrat(
    fontSize: FontSizes.xl,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final TextStyle appBar = GoogleFonts.roboto(
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final TextStyle subtitle = GoogleFonts.montserrat(
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
  );

  static final TextStyle body = GoogleFonts.roboto(
    fontSize: FontSizes.regular,
    color: AppColors.textColor,
  );

  static final TextStyle caption = GoogleFonts.roboto(
    fontSize: FontSizes.small,
    color: AppColors.secondary,
  );

  static final TextStyle description = GoogleFonts.roboto(
    fontSize: FontSizes.small,
    color: AppColors.white,
  );

  static final TextStyle button1 = GoogleFonts.montserrat(
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  static final TextStyle button = GoogleFonts.roboto(
    fontSize: FontSizes.large,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );
}
