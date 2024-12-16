import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/consts/color_res.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  final double size;
  final bool hasBg;

  const LoadingWidget(
      {super.key,
      this.color = AppColors.primary,
      this.size = 24,
      this.hasBg = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hasBg ? AppColors.white.withAlpha(80) : null,
      child: Center(
        child: Platform.isAndroid
            ? SizedBox(
                height: size,
                width: size,
                child: CircularProgressIndicator(
                  color: color,
                ),
              )
            : CupertinoActivityIndicator(
                color: color,
                radius: 12,
              ),
      ),
    );
  }
}
