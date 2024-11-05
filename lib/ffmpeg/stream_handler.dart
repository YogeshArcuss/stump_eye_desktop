import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:stump_eye/ffmpeg/stream_downloader.dart';

class StreamHandler {
  const StreamHandler();

  Future<void> init(String input) async {
    FFMpegHelper ffmpeg = FFMpegHelper.instance;
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final output =
          path.join(appDocDir.path, "${DateTime.now().millisecond}.mp4");
      debugPrint('output: $output');
      final FFMpegCommand cliCommand = FFMpegCommand(
        inputs: [
          FFMpegInput.asset(input),
        ],
        args: [StreamDownloader(input, output)],

        outputFilepath: output, // Use strftime for filename
      );
      await ffmpeg.runAsync(
        cliCommand,
        statisticsCallback: (Statistics statistics) {
          debugPrint('Bitrate: ${statistics.getBitrate()}');
        },
      );

      debugPrint("success=========>");
    } catch (e) {
      debugPrint('Error running FFmpeg command: $e');
    }
  }
}
