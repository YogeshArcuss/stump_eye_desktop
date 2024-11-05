import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:stump_eye/screens/login_screen/login_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  ValueNotifier<FFMpegProgress> downloadProgress =
      ValueNotifier<FFMpegProgress>(
    FFMpegProgress(
      downloaded: 0,
      fileSize: 0,
      phase: FFMpegProgressPhase.inactive,
    ),
  );
  FFMpegHelper ffmpeg = FFMpegHelper.instance;

  Future<void> downloadFFMpeg() async {
    if (Platform.isWindows) {
      bool success = await ffmpeg.setupFFMpegOnWindows(
        onProgress: (FFMpegProgress progress) {
          downloadProgress.value = progress;
        },
      );
      if(success){
  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      }
       
    }
  }

  Future<void> checkFFMpeg() async {
    bool present = await ffmpeg.isFFMpegPresent();
    if (present) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      downloadFFMpeg();
    }
  }

  @override
  void initState() {
    super.initState();
    checkFFMpeg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Platform.isWindows
          ? null
          : AppBar(
              title: const Text('FFMpeg Testing'),
            ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 300,
            child: ValueListenableBuilder(
              valueListenable: downloadProgress,
              builder: (BuildContext context, FFMpegProgress value, _) {
                double? prog;
                if ((value.downloaded != 0) && (value.fileSize != 0)) {
                  prog = value.downloaded / value.fileSize;
                } else {
                  prog = 0;
                }
                if (value.phase == FFMpegProgressPhase.decompressing) {
                  prog = null;
                }
                if (value.phase == FFMpegProgressPhase.inactive) {
                  return const SizedBox.shrink();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(value.phase.name),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(value: prog),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
