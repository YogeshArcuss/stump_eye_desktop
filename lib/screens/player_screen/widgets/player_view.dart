import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class PlayerView extends StatefulWidget {
  PlayerView({super.key, required this.url});

  String url;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late final player = Player(
      configuration: const PlayerConfiguration(logLevel: MPVLogLevel.error));

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
    player.streams.error.listen((error) {
      debugPrint("error2 $error");
    });
    player.streams.log.listen((error) {
      debugPrint("log2 $error");
    });

    // FFmpegKit.execute(
    //         '-hide_banner -y -loglevel error -rtsp_transport tcp -use_wallclock_as_timestamps 1 -i ${widget.url} -vcodec copy -acodec copy -f segment -reset_timestamps 1 -segment_time 900 -segment_format mkv -segment_atclocktime 1 -strftime 1 %Y%m%dT%H%M%S.mkv')
    //     .then((session) async {
    //   final returnCode = await session.getReturnCode();

    //   debugPrint("returnCode2 $returnCode");
    // }).catchError((error) {
    //   debugPrint("error  $error");
    // });
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
