import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_check_project/core/consts/asset_res.dart';
import 'package:skill_check_project/core/consts/color_res.dart';
import 'package:skill_check_project/core/consts/style_res.dart';
import 'package:skill_check_project/features/main/presentation/widgets/primary_png_icon.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.hasIcon,
    this.width,
    this.height,
    this.textStyle,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool? hasIcon;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(AppColors.primary),
            // shadowColor: WidgetStateProperty.all(AppColors.primary),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(height ?? 40.h / 2)),
              ),
            ),
            overlayColor: WidgetStateProperty.all(Colors.grey.withAlpha(40)),
            elevation: WidgetStateProperty.all(0), // Adjust elevation as needed
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textStyle ??
                      golosMedium.copyWith(
                          fontSize: 15.sp, color: AppColors.white),
                ),
                8.horizontalSpace,
                if (hasIcon == true)
                  primaryPngIcon(context,
                      iconPath: AssetRes.icRight, color: AppColors.white)
              ],
            ),
          )),
    );
  }
}
