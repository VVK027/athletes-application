import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/models/athlete_models.dart';
import 'package:video_player/video_player.dart';

class MediaDetailScreen extends StatefulWidget {
  const MediaDetailScreen({super.key, required this.item});

  final MediaItem item;

  @override
  State<MediaDetailScreen> createState() => _MediaDetailScreenState();
}

class _MediaDetailScreenState extends State<MediaDetailScreen> {
  VideoPlayerController? _videoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.item.type == MediaType.video) {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    final path = widget.item.localPath;
    final url = widget.item.remoteUrl;
    VideoPlayerController controller;
    if (path != null && !kIsWeb && File(path).existsSync()) {
      controller = VideoPlayerController.file(File(path));
    } else if (url != null && url.isNotEmpty) {
      controller = VideoPlayerController.networkUrl(Uri.parse(url));
    } else {
      return;
    }
    await controller.initialize();
    if (!mounted) {
      controller.dispose();
      return;
    }
    setState(() {
      _videoController = controller..setLooping(true);
      _videoReady = true;
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(item.title, style: const TextStyle(fontSize: 16)),
      ),
      body: Center(
        child: item.type == MediaType.video ? _buildVideo() : _buildPhoto(item),
      ),
    );
  }

  Widget _buildPhoto(MediaItem item) {
    if (item.localPath != null && !kIsWeb && File(item.localPath!).existsSync()) {
      return InteractiveViewer(
        child: Image.file(File(item.localPath!), fit: BoxFit.contain),
      );
    }
    if (item.hasRemote) {
      return InteractiveViewer(
        child: Image.network(
          item.remoteUrl!,
          fit: BoxFit.contain,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return const CircularProgressIndicator(color: AppTheme.teal);
          },
          errorBuilder: (_, _, _) => _placeholder(item),
        ),
      );
    }
    return _placeholder(item);
  }

  Widget _buildVideo() {
    if (!_videoReady || _videoController == null) {
      return const CircularProgressIndicator(color: AppTheme.teal);
    }
    final controller = _videoController!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          const SizedBox(height: 16),
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: AppTheme.teal,
              bufferedColor: Colors.white24,
              backgroundColor: Colors.white10,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                color: Colors.white,
                onPressed: () {
                  final pos = controller.value.position - const Duration(seconds: 5);
                  controller.seekTo(pos < Duration.zero ? Duration.zero : pos);
                },
                icon: const Icon(Icons.replay_5),
              ),
              const SizedBox(width: 16),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: AppTheme.teal),
                onPressed: () {
                  setState(() {
                    controller.value.isPlaying ? controller.pause() : controller.play();
                  });
                },
                icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
              ),
              const SizedBox(width: 16),
              IconButton(
                color: Colors.white,
                onPressed: () {
                  final pos = controller.value.position + const Duration(seconds: 5);
                  controller.seekTo(pos);
                },
                icon: const Icon(Icons.forward_5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final speed in [0.5, 1.0, 1.5, 2.0])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text('${speed}x', style: const TextStyle(fontSize: 11)),
                    selected: controller.value.playbackSpeed == speed,
                    onSelected: (_) {
                      setState(() {
                        controller.setPlaybackSpeed(speed);
                      });
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder(MediaItem item) {
    return Container(
      color: Color(item.thumbnailColor),
      alignment: Alignment.center,
      child: Icon(
        item.type == MediaType.video ? Icons.videocam : Icons.image,
        size: 64,
        color: Colors.white54,
      ),
    );
  }
}
