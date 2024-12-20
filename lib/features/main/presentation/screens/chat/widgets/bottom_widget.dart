import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/consts/color_res.dart';
import '../../../../../../core/consts/style_res.dart';
import '../../../widgets/primary_button.dart';
import '../../recitation/recitation_screen.dart';

class BottomWidget extends StatelessWidget {
  final VoidCallback onTap;

  const BottomWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      height: 96.h,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 64.h,
            padding: EdgeInsets.only(left: 20.w, right: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32.r)),
              color: AppColors.background,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Qiroatni tekshirish...",
                    style: golosMedium.copyWith(
                        fontSize: 14.sp, color: AppColors.timeColor),
                  ),
                ),
                PrimaryButton(
                    title: "Qiroat qilish", hasIcon: true, onPressed: onTap)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
