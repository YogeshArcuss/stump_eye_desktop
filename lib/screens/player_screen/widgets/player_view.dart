import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:stump_eye/ffmpeg/stream_handler.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key, required this.url});

  final String url;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late final player = Player(configuration: const PlayerConfiguration());
  final steamHandler = StreamHandler();
  late final controller;

  @override
  void initState() {
    super.initState();
    controller = VideoController(player);
    player.open(Media(widget.url));
    player.stream.completed.listen((e) {
      debugPrint("completed:- $e");
      if (e) {
        player.open(Media(widget.url));
      }
    });

    steamHandler.init(widget.url);
    Future.delayed(Duration(minutes: 1), () {
      debugPrint("completed Ended");
      steamHandler.stop();
    });
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
