import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:skill_check_project/core/theme/app_theme.dart';
import 'package:skill_check_project/features/main/presentation/screens/chat/chat_screen.dart';

import 'core/consts/app_res.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: false,
        designSize: MediaQuery.sizeOf(context),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Skill Check Task',
            themeMode: ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: ChatScreen(),
          );
        });
  }
}
