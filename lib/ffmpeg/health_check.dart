import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:flutter/material.dart';

class HealthCheck implements CliArguments {
  final String input;

  const HealthCheck(this.input);

  @override
  List<String> toArgs() {
    final args = [
      "-rtsp_transport",
      "tcp",
      '-i',
      input,
      "-t",
      "1",
      "-f",
      "null",
      "-"
    ];
    debugPrint("args HealthCheck ${args.toString()}");
    return args;
  }
}
