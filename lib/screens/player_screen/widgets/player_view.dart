import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
import 'package:stump_eye/arguments/stream_downloader.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';

class PlayerView extends StatefulWidget {
  PlayerView({super.key, required this.url});

  String url;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late final player = Player(
      configuration: const PlayerConfiguration());

  late final controller;

  @override
  void initState() {
    super.initState();
    controller = VideoController(player);

    player.open(Media(widget.url));

    player.stream.error.listen((error) {
      final snackBar =
          SnackBar(content: Text(error), backgroundColor: Colors.red);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    // player.streams.error.listen((error) {
    //   // debugPrint("error2 $error");
    // });
    // player.streams.log.listen((error) {
    //   // debugPrint("log2 $error");
    // });
    startFFMPEGRecording();

    // FFmpegKit.execute(
    //         '-hide_banner -y -loglevel error -rtsp_transport tcp -use_wallclock_as_timestamps 1 -i ${widget.url} -vcodec copy -acodec copy -f segment -reset_timestamps 1 -segment_time 900 -segment_format mkv -segment_atclocktime 1 -strftime 1 %Y%m%dT%H%M%S.mkv')
    //     .then((session) async {
    //   final returnCode = await session.getReturnCode();

    //   debugPrint("returnCode2 $returnCode");
    // }).catchError((error) {
    //   debugPrint("error  $error");
    // });
  }


  Future<void> startFFMPEGRecording () async {
  FFMpegHelper ffmpeg = FFMpegHelper.instance;

  try {
      final appDocDir = await getApplicationDocumentsDirectory();
        final output = path.join(appDocDir.path, "${DateTime.now().millisecond}.mp4");
            debugPrint('output: $output'); // You can add more stats here
  final FFMpegCommand cliCommand = FFMpegCommand(
    inputs: [
      FFMpegInput.asset(widget.url), // The RTSP stream URL (from widget)
    ],
    args: [
    StreamDownloader(widget.url,output)
    ],
    
    outputFilepath: output, // Use strftime for filename
  );
  FFMpegHelperSession session = await ffmpeg.runAsync(
    cliCommand,
    statisticsCallback: (Statistics statistics) {
      debugPrint('Bitrate: ${statistics.getBitrate()}'); // You can add more stats here
    },
  );
  
   debugPrint("success=========> ${session != null}");
} catch (e) {
  debugPrint('Error running FFmpeg command: $e');
}

  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      fit: BoxFit.cover,
      controller: controller,
    );
  }
}
