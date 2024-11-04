import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:stump_eye/helpers/app_colors.dart';
import 'package:stump_eye/screens/login_screen/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const LoginScreen(),
    );
  }
}
