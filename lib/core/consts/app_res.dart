import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:skill_check_project/core/consts/style_res.dart';

import 'color_res.dart';

class AppRes {
  static final logger = Logger();

  static void showSnackBar(BuildContext context, String title) {
    final snackBar = SnackBar(
      content: Text(
        title,
        style: golosMedium.copyWith(fontSize: 16, color: AppColors.primaryTextColor),
      ),
      backgroundColor: AppColors.white,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      elevation: 30,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
