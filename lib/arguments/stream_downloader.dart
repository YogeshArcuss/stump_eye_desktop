import 'package:ffmpeg_helper/ffmpeg_helper.dart';

class StreamDownloader implements CliArguments {
  final String input;
  final String output;


  const StreamDownloader(this.input, this.output);
  @override
  List<String> toArgs() {
    return [
    "-hide_banner",
    "-y","-loglevel","error","-rtsp_transport","tcp","-use_wallclock_as_timestamps","1","-i",input,"-vcodec",
    "c","copy","-acodec","copy","-f","segment","-reset_timestamps","1","-segment_time","900","-segment_format",
    "mkv","-segment_atclocktime","1","-strftime","1",
output
    ];
  }
}
