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
  bool isPlayerActive = false;
  bool thumbnailError = false;

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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? videoId = YoutubePlayer.convertUrlToId(Constants.videoUrl);
    String thumbnailUrl = "https://img.youtube.com/vi/$videoId/0.jpg";

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
            child: isPlayerActive
                ? YoutubePlayer(controller: controller)
                : GestureDetector(
              onTap: () {
                setState(() {
                  isPlayerActive = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200.h, // Player bilan bir xil balandlik
                    color: AppColors.iconColor,
                    child: thumbnailError
                        ? Center(
                      child: Text(
                        "Thumbnail yuklab bo'lmadi",
                        style: golosMedium.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    )
                        : Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200.h,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        setState(() {
                          thumbnailError = true;
                        });
                        return Center(
                          child: Text(
                            "Internet yo'q yoki xato yuz berdi",
                            style: golosMedium.copyWith(
                                fontSize: 14, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  if (!thumbnailError)
                    Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 50,
                    ),
                ],
              ),
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
