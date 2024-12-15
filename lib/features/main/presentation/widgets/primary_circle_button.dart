import 'package:flutter/material.dart';
import 'package:skill_check_project/core/consts/color_res.dart';
import 'package:skill_check_project/features/main/presentation/widgets/primary_png_icon.dart';

class PrimaryCircleButton extends StatelessWidget {
  const PrimaryCircleButton({
    super.key,
    required this.iconPath,
    this.iconColor,
    this.backgroundColor,
    required this.onPressed,
    this.width,
    this.height,
  });

  final String iconPath;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 64,
      width: width ?? 64,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(backgroundColor ?? AppColors.primary),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(height ?? 64 / 2)),
                ),
              ),
              overlayColor: WidgetStateProperty.all(Colors.grey.withAlpha(40)),
              elevation: WidgetStateProperty.all(0)),
          child: primaryPngIcon(context,
              iconPath: iconPath, color: iconColor ?? AppColors.white)),
    );
  }
}
