import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_check_project/features/main/presentation/screens/chat/chat_screen.dart';

Widget primaryPngIcon(
    BuildContext context, {
      required String iconPath,
      required Color color,
      VoidCallback? onTapCallback,
      double? size,
    }) {
  return InkWell(
    onTap: onTapCallback,
    borderRadius: BorderRadius.circular(20.r),
    child: Center(
      child: Padding(
        padding:  EdgeInsets.all(onTapCallback != null ? 8 : 0),
        child: Image.asset(
          iconPath,
          height: size ?? 24,
          width: size ?? 24,
          color: color,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
