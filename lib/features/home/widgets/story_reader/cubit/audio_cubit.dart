import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ico_story_app/core/services/app_logger.dart';

class AudioState {
  const AudioState({
    this.isPlaying = false,
    this.isLoading = true,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.error,
  });

  final bool isPlaying;
  final bool isLoading;
  final Duration currentPosition;
  final Duration totalDuration;
  final String? error;

  double get progress => totalDuration.inMilliseconds > 0
      ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
      : 0.0;

  AudioState copyWith({
    bool? isPlaying,
    bool? isLoading,
    Duration? currentPosition,
    Duration? totalDuration,
    String? error,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      error: error,
    );
  }

  @override
  String toString() {
    final currentSec = currentPosition.inSeconds;
    final totalSec = totalDuration.inSeconds;
    return 'AudioState(playing: $isPlaying, loading: $isLoading, '
        'time: ${currentSec ~/ 60}:${(currentSec % 60).toString().padLeft(2, '0')}/'
        '${totalSec ~/ 60}:${(totalSec % 60).toString().padLeft(2, '0')}'
        '${error != null ? ', error: $error' : ''})';
  }
}

class AudioCubit extends Cubit<AudioState> {
  AudioCubit({required this.audioAssetPath})
      : _audioPlayer = AudioPlayer(),
        super(const AudioState());

  final String audioAssetPath;
  final AudioPlayer _audioPlayer;

  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;
  StreamSubscription<void>? _completeSubscription;

  Future<void> initialize() async {
    AppLogger.info('AudioCubit: Initializing for $audioAssetPath');
    await _setupAudioListeners();
    await _loadAudio();
  }

  Future<void> _setupAudioListeners() async {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      AppLogger.debug('Audio: duration received ${duration.inSeconds}s');
      emit(state.copyWith(
        totalDuration: duration,
        isLoading: false,
      ));
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      emit(state.copyWith(currentPosition: position));
    });

    _stateSubscription = _audioPlayer.onPlayerStateChanged.listen((playerState) {
      final isPlaying = playerState == PlayerState.playing;
      AppLogger.debug('Audio: state changed -> ${isPlaying ? "PLAYING" : "PAUSED/STOPPED"}');
      emit(state.copyWith(isPlaying: isPlaying));
    });

    _completeSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      AppLogger.info('Audio: playback completed');
      emit(state.copyWith(
        isPlaying: false,
        currentPosition: Duration.zero,
      ));
    });
  }

  Future<void> _loadAudio() async {
    try {
      AppLogger.info('AudioCubit: Loading audio source...');
      await _audioPlayer.setSource(AssetSource(audioAssetPath));
      AppLogger.success('AudioCubit: Source loaded successfully');
    } catch (e) {
      AppLogger.error('AudioCubit: Failed to load audio', error: e);
      emit(state.copyWith(
        isLoading: false,
        error: 'Audio loading error: $e',
      ));
    }
  }

  Future<void> togglePlayPause() async {
    AppLogger.info('Audio: togglePlayPause (currently ${state.isPlaying ? "playing" : "paused"})');
    if (state.isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> seekTo(Duration position) async {
    AppLogger.debug('Audio: seeking to ${position.inSeconds}s');
    await _audioPlayer.seek(position);
  }

  Future<void> restart() async {
    AppLogger.debug('Audio: restarting');
    await _audioPlayer.seek(Duration.zero);
  }

  void handleAppLifecyclePause() {
    if (state.isPlaying) {
      AppLogger.info('Audio: pausing on lifecycle pause');
      _audioPlayer.pause();
    }
  }

  @override
  Future<void> close() async {
    AppLogger.info('AudioCubit: closing');
    await _durationSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _stateSubscription?.cancel();
    await _completeSubscription?.cancel();
    await _audioPlayer.dispose();
    await super.close();
  }
}
