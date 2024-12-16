import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_check_project/core/consts/color_res.dart';
import 'package:skill_check_project/features/main/data/models/recitation_model.dart';
import 'package:skill_check_project/features/main/presentation/bloc/chat/chat_bloc.dart';
import 'package:skill_check_project/features/main/presentation/screens/chat/widgets/bottom_widget.dart';
import 'package:skill_check_project/features/main/presentation/screens/chat/widgets/recitation_item_widget.dart';
import 'package:skill_check_project/features/main/presentation/screens/chat/widgets/youtube_video_card_widget.dart';
import 'package:skill_check_project/features/main/presentation/screens/recitation/recitation_screen.dart';
import 'package:skill_check_project/features/main/presentation/widgets/primary_app_bar.dart';

import '../../../../../core/consts/app_res.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _bloc = ChatBloc();

  @override
  void initState() {
    _bloc.add(GetAllRecitationsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatError) {
              AppRes.showSnackBar(context, state.errorText);
            }
            if (state is ChatSuccess) {
              AppRes.showSnackBar(context, state.message);
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SafeArea(child: primaryAppBar(context, title: "Fotiha Surasi")),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 31),
                          child: YoutubeVideoCardWidget(),
                        ),
                        // 8.verticalSpace,
                        state is ChatGetRecitationsSuccess &&
                                state.recitationList.isNotEmpty
                            ?  _buildRecitationsList(state.recitationList)
                            : 0.verticalSpace
                      ],
                    ),
                  ),
                ),
                BottomWidget(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecitationScreen()),
                    );
                    if (result == true) {
                      _bloc.add(GetAllRecitationsEvent());
                    }
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecitationsList(List<RecitationModel> recitationList) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return RecitationItemWidget(
            recitationModel: recitationList[index],
          );
        },
        separatorBuilder: (_, __) {
          return 8.verticalSpace;
        },
        itemCount: recitationList.length);
  }
}
