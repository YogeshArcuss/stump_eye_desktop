import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:stump_eye/ffmpeg/health_check.dart';
import 'package:stump_eye/ffmpeg/stream_downloader.dart';

class StreamHandler {
  StreamHandler();
  FFMpegHelperSession? session;
  FFMpegHelper ffmpeg = FFMpegHelper.instance;
  Future<void> init(String input) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final output =
          path.join(appDocDir.path, "${DateTime.now().millisecond}.mp4");
      debugPrint('output: $output');
      final FFMpegCommand cliCommand = FFMpegCommand(
        inputs: [
          FFMpegInput.asset(input),
        ],
        args: [
          StreamDownloader(input, output),
          const LogLevelArgument(LogLevel.error)
        ],

        outputFilepath: output, // Use strftime for filename
      );
      var count = 0;
      session = await ffmpeg.runAsync(
        cliCommand,
        statisticsCallback: (Statistics statistics) {
          count++;
          debugPrint('Bitrate: ${statistics.getBitrate()} ${count}');
        },
      );

      debugPrint("success=========>");
    } catch (e) {
      debugPrint('Error running FFmpeg command: $e');
    }
  }

  void stop() {
    if (session != null) {
      session!.cancelSession();
    }
  }

  Future<bool> checkIsAliveOrNot(String input) async {
    final FFMpegCommand cliCommand = FFMpegCommand(
      inputs: [
        FFMpegInput.asset(input),
      ],
      args: [HealthCheck(input), const LogLevelArgument(LogLevel.error)],
      outputFilepath: "/dev/null",
    );

    try {
      // Run the ffmpeg command asynchronously
      FFMpegHelperSession result = await ffmpeg.runAsync(
        cliCommand,
        statisticsCallback: (Statistics statistics) {
          debugPrint('Health Bitrate: ${statistics.getBitrate()}');
        },
        onComplete: (outputFile) {
          debugPrint('Health outputFile' + outputFile!.path);
        },
      );
      final logs = await result.nonWindowSession!.getReturnCode();

      debugPrint('Health check passed for: ${logs.hashCode}');
      return true;
    } catch (e) {
      debugPrint('FFMpeg failed: $e');
      return false;
    }
  }
}
