import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

class AppText {
  static Text extraBoldText(String text,
      {double size = 15,
        Color color = AppColors.text,
        TextAlign align = TextAlign.start,
        TextOverflow overflow = TextOverflow.clip}) =>
      Text(
        text,
        textAlign: align,
        overflow: overflow,
        style: AppTextStyle.extraBoldTextStyle(size: size, color: color),
      );
  static Text boldText(String text,
          {double size = 15,
          Color color = AppColors.text,
          TextAlign align = TextAlign.start,
          TextOverflow overflow = TextOverflow.clip}) =>
      Text(
        text,
        textAlign: align,
        overflow: overflow,
        style: AppTextStyle.boldTextStyle(size: size, color: color),
      );

  static regularText(String text,
          {double size = 15,
          Color color = AppColors.text,
          TextAlign align = TextAlign.start}) =>
      Text(
        text,
        textAlign: align,
        style: AppTextStyle.regularTextStyle(size: size, color: color),
      );

  static lightText(String text,
          {double size = 15,
          Color color = AppColors.text,
          TextAlign align = TextAlign.start}) =>
      Text(
        text,
        textAlign: align,
        style: AppTextStyle.lightTextStyle(size: size, color: color),
      );

  static mediumText(String text,
          {double size = 15,
          Color color = AppColors.text,
          TextAlign align = TextAlign.start,
          TextOverflow overflow = TextOverflow.clip}) =>
      Text(
        text,
        textAlign: align,
        overflow: overflow,
        style: AppTextStyle.mediumTextStyle(size: size, color: color),
      );
}
