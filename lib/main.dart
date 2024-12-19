import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skill_check_project/core/theme/app_theme.dart';
import 'package:skill_check_project/features/main/presentation/screens/chat/chat_screen.dart';

import 'core/consts/app_res.dart';
import 'core/helpers/audio_handler.dart';

// late AudioHandler audioHandler;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // audioHandler = await AudioService.init(
  //   builder: () => AudioPlayerHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.example.app.channel.audio',
  //     androidNotificationChannelName: 'Audio Playback',
  //     androidNotificationOngoing: true,
  //   ),
  // );
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await initDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

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
            home: ChatScreen(
              // audioHandler: audioHandler,
            ),
          );
        });
  }
}
