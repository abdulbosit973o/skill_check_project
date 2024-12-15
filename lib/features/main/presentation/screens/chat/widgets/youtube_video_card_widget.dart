import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_check_project/core/consts/color_res.dart';
import 'package:skill_check_project/core/consts/constants.dart';
import 'package:skill_check_project/core/consts/style_res.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoCardWidget extends StatefulWidget {
  const YoutubeVideoCardWidget({super.key});

  @override
  State<YoutubeVideoCardWidget> createState() => _YoutubeVideoCardWidgetState();
}

class _YoutubeVideoCardWidgetState extends State<YoutubeVideoCardWidget> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(Constants.videoUrl)!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          captionLanguage: "uz",
          loop: false,
          enableCaption: true,
        )
        // autoPlay: false,
        // params: YoutubePlayerParams(

        // ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.background,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: YoutubePlayer(
              controller: controller,
            ),
          ),
          8.verticalSpace,
          Text(
            "Fotiha surasida yo‘l qo‘yilishi mumkin bo‘lgan xatolar",
            style: golosMedium.copyWith(fontSize: 14),
          )
        ],
      ),
    );
  }
}
