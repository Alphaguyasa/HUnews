import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String videoUrl;

  const VideoScreen({super.key, required this.videoUrl});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  bool isPlayerReady = false;
  String? videoId;

  @override
  void initState() {
    super.initState();

    // Extract video ID from URL
    videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          controlsVisibleAtStart: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (videoId != null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B365D),
        title: const Text(
          'Watch Video',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: videoId == null
            ? Center(
          child: Text(
            "Invalid YouTube URL",
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: const Color(0xFFF6B331),
            onReady: () {
              setState(() {
                isPlayerReady = true;
              });
              debugPrint('YouTube Player is ready.');
            },
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
                colors: ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.white,
                  backgroundColor: Colors.grey.shade300,
                  bufferedColor: Colors.grey.shade400,
                ),
              ),
              RemainingDuration(),
              PlaybackSpeedButton(),
            ],
          ),
          builder: (context, player) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Rounded video player
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: player,
                  ),
                ),
                const SizedBox(height: 20),

                // Video info
                Text(
                  "Playing from: ${widget.videoUrl}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF1B365D),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                if (!isPlayerReady)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}