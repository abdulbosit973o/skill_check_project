import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_check_project/core/consts/color_res.dart';
import 'package:skill_check_project/core/consts/style_res.dart';
import 'package:skill_check_project/features/main/presentation/screens/chat/widgets/youtube_video_card_widget.dart';
import 'package:skill_check_project/features/main/presentation/screens/recitation/recitation_screen.dart';
import 'package:skill_check_project/features/main/presentation/widgets/primary_app_bar.dart';
import 'package:skill_check_project/features/main/presentation/widgets/primary_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(child: primaryAppBar(context, title: "Fotiha Surasi")),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 31),
                    child: YoutubeVideoCardWidget(),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.r),
            height: 101.h,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 64,
                  padding: EdgeInsets.only(left: 20, right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
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
                              fontSize: 14, color: AppColors.timeColor),
                        ),
                      ),
                      PrimaryButton(
                        title: "Qiroat qilish",
                        hasIcon: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecitationScreen()),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
