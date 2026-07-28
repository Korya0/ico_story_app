
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
