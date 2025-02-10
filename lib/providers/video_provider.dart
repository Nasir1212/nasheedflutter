// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProvider extends ChangeNotifier {
  late VideoPlayerController _controller;

  VideoPlayerController get controller => _controller;

  bool get isInitialized => _controller.value.isInitialized;

  Duration get videoPosition => _controller.value.position;

  Duration get videoDuration => _controller.value.duration;

  double get videoProgress =>
      isInitialized ? videoPosition.inMilliseconds / videoDuration.inMilliseconds : 0.0;

  void initializeVideo(String videoUrl) {
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        notifyListeners(); // Notify the UI when the video is ready
      });
  }

  void playPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    notifyListeners();
  }

  void stopVideo() {
    _controller.pause();
    _controller.seekTo(Duration.zero);
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}