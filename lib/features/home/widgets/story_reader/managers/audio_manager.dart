import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  AudioManager({required this.audioAssetPath, required this.onStateChanged});
  final String audioAssetPath;
  final VoidCallback onStateChanged;

  late AudioPlayer _audioPlayer;

  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;
  StreamSubscription<void>? _completeSubscription;

  bool isPlaying = false;
  bool isLoading = true;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  double playbackSpeed = 1;
  double volume = 0.8;

  Future<void> initialize() async {
    _audioPlayer = AudioPlayer();
    await _setupAudioListeners();
    await _loadAudio();
  }

  Future<void> _setupAudioListeners() async {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      totalDuration = duration;
      isLoading = false;
      onStateChanged();
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      currentPosition = position;
      onStateChanged();
    });

    _stateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
      onStateChanged();
    });

    _completeSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      isPlaying = false;
      currentPosition = Duration.zero;
      onStateChanged();
    });
  }

  Future<void> _loadAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource(audioAssetPath));
    } catch (e) {
      debugPrint('Audio loading error: $e');
      isLoading = false;
      onStateChanged();
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } catch (e) {
      debugPrint('Play/Pause error: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('Seek error: $e');
    }
  }

  Future<void> restart() async {
    await seekTo(Duration.zero);
  }

  Future<void> setSpeed(double speed) async {}

  Future<void> setVolume(double vol) async {}

  Future<void> handleAppLifecyclePause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      }
    } catch (e) {
      debugPrint('Lifecycle pause error: $e');
    }
  }

  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _stateSubscription?.cancel();
    _completeSubscription?.cancel();
    _audioPlayer.dispose();
  }
}
