import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:stump_eye/helpers/app_colors.dart';
import 'package:stump_eye/screens/setup_screen/setup_screen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setSize(const Size(755, 545));
      await windowManager.setMinimumSize(const Size(350, 600));
      await windowManager.setMinimizable(true);

      await windowManager.center();
      await windowManager.show();
    });
  }
  await FFMpegHelper.instance.initialize();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stump Eye',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: const SetupScreen(),
    );
  }
}
