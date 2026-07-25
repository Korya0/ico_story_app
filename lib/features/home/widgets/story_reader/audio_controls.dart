import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/cubit/audio_cubit.dart';

class AudioControls extends StatefulWidget {
  const AudioControls({
    required this.categoryColor,
    super.key,
  });
  final Color categoryColor;

  @override
  State<AudioControls> createState() => _AudioControlsState();
}

class _AudioControlsState extends State<AudioControls>
    with TickerProviderStateMixin {
  late AnimationController _playButtonController;
  late AnimationController _waveController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _waveAnimation;
  bool _isSliderDragging = false;
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    final cubit = context.read<AudioCubit>();
    if (cubit.state.isPlaying) {
      _waveController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _playButtonController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  void _updateAnimations(bool isPlaying) {
    if (isPlaying) {
      _waveController.repeat(reverse: true);
    } else {
      _waveController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        final cubit = context.read<AudioCubit>();
        _updateAnimations(state.isPlaying);

        return Container(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.categoryColor.withValues(alpha: 0.9),
                AppColors.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isTablet ? 24 : 20),
              topRight: Radius.circular(isTablet ? 24 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.categoryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _TitleSection(
                isPlaying: state.isPlaying,
                waveAnimation: _waveAnimation,
                isTablet: isTablet,
              ),
              Gap(isTablet ? 20 : 16),
              _TimeDisplay(
                currentPosition: state.currentPosition,
                totalDuration: state.totalDuration,
                isSliderDragging: _isSliderDragging,
                sliderValue: _sliderValue,
                isTablet: isTablet,
              ),
              Gap(isTablet ? 16 : 12),
              _ProgressSlider(
                progress: state.progress,
                isSliderDragging: _isSliderDragging,
                sliderValue: _sliderValue,
                isTablet: isTablet,
                onChangeStart: (value) {
                  setState(() {
                    _isSliderDragging = true;
                    _sliderValue = value;
                  });
                  HapticFeedback.lightImpact();
                },
                onChanged: _onSliderChanged,
                onChangeEnd: (value) {
                  final position = Duration(
                    milliseconds:
                        (value * state.totalDuration.inMilliseconds).round(),
                  );
                  cubit.seekTo(position);
                  setState(() {
                    _isSliderDragging = false;
                  });
                  HapticFeedback.selectionClick();
                },
              ),
              Gap(isTablet ? 20 : 16),
              _ControlButtons(
                isPlaying: state.isPlaying,
                isLoading: state.isLoading,
                currentPosition: state.currentPosition,
                scaleAnimation: _scaleAnimation,
                playButtonController: _playButtonController,
                categoryColor: widget.categoryColor,
                isTablet: isTablet,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TitleSection extends AnimatedWidget {
  const _TitleSection({
    required this.isPlaying,
    required Animation<double> waveAnimation,
    required this.isTablet,
  }) : super(listenable: waveAnimation);

  final bool isPlaying;
  final bool isTablet;

  Animation<double> get _waveAnimation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = (_waveAnimation.value + delay) % 1.0;
            return Container(
              width: 3,
              height: 16 + (8 * animationValue),
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: isPlaying
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        const Gap(12),
        const Spacer(),
        Icon(
          isPlaying ? Icons.volume_up : Icons.volume_off,
          color: AppColors.textPrimary.withValues(alpha: 0.8),
          size: isTablet ? 22 : 20,
        ),
      ],
    );
  }
}

class _TimeDisplay extends StatelessWidget {
  const _TimeDisplay({
    required this.currentPosition,
    required this.totalDuration,
    required this.isSliderDragging,
    required this.sliderValue,
    required this.isTablet,
  });

  final Duration currentPosition;
  final Duration totalDuration;
  final bool isSliderDragging;
  final double sliderValue;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TimeText(
            time: _formatDuration(
              isSliderDragging
                  ? Duration(
                      milliseconds:
                          (sliderValue * totalDuration.inMilliseconds).round(),
                    )
                  : currentPosition,
            ),
            isTablet: isTablet,
            label: AppStrings.current,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 12 : 8,
              vertical: isTablet ? 6 : 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
            ),
            child: Icon(
              Icons.headphones,
              color: Colors.white,
              size: isTablet ? 18 : 16,
            ),
          ),
          _TimeText(
            time: _formatDuration(totalDuration),
            isTablet: isTablet,
            label: AppStrings.total,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class _TimeText extends StatelessWidget {
  const _TimeText({
    required this.time,
    required this.isTablet,
    required this.label,
  });

  final String time;
  final bool isTablet;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          time,
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          label,
          fontSize: isTablet ? 12 : 10,
          color: Colors.white.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

class _ProgressSlider extends StatelessWidget {
  const _ProgressSlider({
    required this.progress,
    required this.isSliderDragging,
    required this.sliderValue,
    required this.isTablet,
    required this.onChangeStart,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final double progress;
  final bool isSliderDragging;
  final double sliderValue;
  final bool isTablet;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withValues(alpha: 0.1),
            trackHeight: isTablet ? 6 : 4,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: isTablet ? 12 : 10,
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: isTablet ? 20 : 16,
            ),
          ),
          child: Slider(
            value: isSliderDragging ? sliderValue : progress,
            onChangeStart: onChangeStart,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final dotProgress = (index + 1) / 5;
            final isActive = progress >= dotProgress;
            return Container(
              width: isTablet ? 8 : 6,
              height: isTablet ? 8 : 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ControlButtons extends StatelessWidget {
  const _ControlButtons({
    required this.isPlaying,
    required this.isLoading,
    required this.currentPosition,
    required this.scaleAnimation,
    required this.playButtonController,
    required this.categoryColor,
    required this.isTablet,
  });

  final bool isPlaying;
  final bool isLoading;
  final Duration currentPosition;
  final Animation<double> scaleAnimation;
  final AnimationController playButtonController;
  final Color categoryColor;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AudioCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SecondaryButton(
          icon: Icons.replay_10,
          onTap: () {
            cubit.seekTo(currentPosition - const Duration(seconds: 10));
            HapticFeedback.lightImpact();
          },
          isTablet: isTablet,
        ),
        GestureDetector(
          onTapDown: (_) {
            playButtonController.forward();
          },
          onTapUp: (_) {
            playButtonController.reverse();
          },
          onTapCancel: playButtonController.reverse,
          onTap: () {
            cubit.togglePlayPause();
            HapticFeedback.mediumImpact();
          },
          child: AnimatedBuilder(
            animation: scaleAnimation,
            builder: (_, child) {
              return Transform.scale(
                scale: scaleAnimation.value,
                child: Container(
                  width: isTablet ? 70 : 60,
                  height: isTablet ? 70 : 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: isTablet ? 28 : 24,
                            height: isTablet ? 28 : 24,
                            child: CircularProgressIndicator(
                              color: categoryColor,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: categoryColor,
                          size: isTablet ? 36 : 32,
                        ),
                ),
              );
            },
          ),
        ),
        _SecondaryButton(
          icon: Icons.forward_10,
          onTap: () {
            cubit.seekTo(currentPosition + const Duration(seconds: 10));
            HapticFeedback.lightImpact();
          },
          isTablet: isTablet,
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.onTap,
    required this.isTablet,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isTablet ? 50 : 44,
        height: isTablet ? 50 : 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: Colors.white, size: isTablet ? 24 : 22),
      ),
    );
  }
}
