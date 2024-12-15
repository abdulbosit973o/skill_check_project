import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/consts/asset_res.dart';
import '../../../../../../../core/consts/color_res.dart';
import '../../../../widgets/primary_png_icon.dart';

class WaveAnimation extends StatefulWidget {
  final VoidCallback onTap;

  const WaveAnimation({super.key, required this.onTap});

  @override
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WavePainter(_controller),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(44.r),
        child: SizedBox(
          width: 88,
          height: 88,
          child: Center(
            child: primaryPngIcon(context,
                iconPath: AssetRes.icStop, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;

  WavePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.waveColor
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = AppColors.secondWaveColor
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // First wave
    for (double i = 0; i < 2 * pi; i += 0.2) {
      double offset = sin(animation.value * 2 * pi + i) * 4;
      canvas.drawCircle(
        center + Offset(cos(i) * offset, sin(i) * offset),
        radius - 10 * (i / (2 * pi)),
        paint,
      );
    }

    // Second wave (opposite motion)
    for (double i = 0; i < 2 * pi; i += 0.2) {
      double offset = -sin(animation.value * 2 * pi + i) * 4;
      canvas.drawCircle(
        center + Offset(cos(i) * offset, sin(i) * offset),
        radius - 10 * (i / (2 * pi)),
        paint2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
