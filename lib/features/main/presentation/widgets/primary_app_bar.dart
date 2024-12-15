import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_check_project/core/consts/asset_res.dart';
import 'package:skill_check_project/core/consts/color_res.dart';
import 'package:skill_check_project/features/main/presentation/widgets/primary_png_icon.dart';

Widget primaryAppBar(
  BuildContext context, {
  VoidCallback? onBackPressed,
  required String title,
}) =>
    SafeArea(
      child: Container(
        height: 55.h,
        margin: const EdgeInsets.all(10),
        child: Center(
          child: AppBar(
            scrolledUnderElevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            leading: onBackPressed != null
                ? Center(
                    child: primaryPngIcon(context,
                        iconPath: AssetRes.icBack,
                        color: AppColors.backIconColor,
                        onTapCallback: onBackPressed),
                  )
                : null,
            centerTitle: true,
            title: Text(title),
          ),
        ),
      ),
    );
