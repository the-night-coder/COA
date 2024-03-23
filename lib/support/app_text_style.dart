import 'package:flutter/material.dart';

import 'app_colors.dart';

const font = 'Noto';

class AppTextStyle {
  static extraBoldTextStyle({
    double size = 15,
    Color color = AppColors.primary,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w900,
      );

  static boldTextStyle({
    double size = 15,
    Color color = AppColors.primary,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w700,
      );

  static regularTextStyle({
    double size = 15,
    Color color = AppColors.primary,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w400,
      );

  static mediumTextStyle({
    double size = 15,
    Color color = AppColors.text,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w500,
      );

  static lightTextStyle({
    double size = 15,
    Color color = AppColors.primary,
  }) =>
      TextStyle(
        fontFamily: font,
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w200,
      );
}
