import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerViewModel with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  bool get isPlaying => _player.playing; // Add getters for other states
  Duration? get duration => _player.duration;
  Duration get currentPosition => _player.position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;

  double _listenCurrentPosition = 0.0;
  double get listenCurrentPosition => _listenCurrentPosition;

  AudioPlayerViewModel() {
    // Listen for changes in player duration
    _durationSubscription = _player.durationStream.listen((duration) {
      notifyListeners();
    });

    // Listen for changes in player position
    _positionSubscription = _player.positionStream.listen((position) {
      _updateListenCurrentPosition();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> setAudioSource(String source) async {
    await _player.setAudioSource(AudioSource.uri(Uri.parse(source)));
    notifyListeners(); // Notify UI of changes
    playOrPause();
  }

  void play() {
    _player.play();
    notifyListeners();
  }

  void pause() {
    _player.pause();
    notifyListeners();
  }

  void stop() {
    _player.stop();
    notifyListeners();
  }

  void playOrPause() {
    if (player.playing) {
      pause();
    } else {
      play();
    }
    notifyListeners();
  }

  String get formattedDuration {
    if (duration != null) {
      return formatDuration(duration!);
    } else {
      return '0:00';
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inMinutes}:${twoDigitSeconds}';
  }

  void _updateListenCurrentPosition() {
    if (duration != null && duration!.inMilliseconds > 0) {
      final newPosition =
          currentPosition.inMilliseconds / duration!.inMilliseconds;
      _listenCurrentPosition = newPosition.clamp(
          0.0, 1.0); // Ensure the value stays within the range [0, 1]
    } else {
      _listenCurrentPosition = 0.0;
    }
    notifyListeners();
  }

  String get formattedCurrentPosition {
    if (currentPosition != null) {
      return formatDurationCurrentPosition(currentPosition);
    } else {
      return '0:00';
    }
  }

  String formatDurationCurrentPosition(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
