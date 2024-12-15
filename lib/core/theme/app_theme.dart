import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill_check_project/core/consts/style_res.dart';

import '../consts/color_res.dart';

class AppTheme {
  static ThemeData get lightTheme {
    ThemeData base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.backIconColor),
        centerTitle: true,
        elevation: 0,
        titleTextStyle: golosMedium.copyWith(
          color: AppColors.primaryTextColor,       
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    ThemeData base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundDark,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.appBarDark,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.white),
        centerTitle: true,
        elevation: 0,
        titleTextStyle: golosMedium.copyWith(
          color: AppColors.white,       
          fontSize: 14,
        ),
      ),
    );
  }
}
