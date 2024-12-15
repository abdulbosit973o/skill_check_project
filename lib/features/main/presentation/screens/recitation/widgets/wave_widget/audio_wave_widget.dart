import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_check_project/core/consts/color_res.dart';
import 'package:skill_check_project/features/main/presentation/screens/chat/chat_screen.dart';

class AudioWaveWidget extends StatefulWidget {
  const AudioWaveWidget({super.key});

  @override
  State<AudioWaveWidget> createState() => _AudioWaveWidgetState();
}

class _AudioWaveWidgetState extends State<AudioWaveWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43.h,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        color: AppColors.white
      ),
    );
  }
}
