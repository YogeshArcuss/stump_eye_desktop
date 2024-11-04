import 'package:flutter/material.dart';

import 'package:stump_eye/screens/player_screen/widgets/player_view.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen({super.key, required this.url});

  String url;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:
                (constraints.maxWidth / 2) / (constraints.maxHeight / (4 / 2)),
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius:
                    BorderRadius.circular(15), // Optional: rounded corners
              ),
              child: PlayerView(
                url: widget.url,
                // url:
                //     "https://videos.pexels.com/video-files/2169880/2169880-uhd_2560_1440_30fps.mp4",
              ),
            ); // Your PlayerView widget
          },
        );
      },
    );
  }
}
