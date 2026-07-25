import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ico_story_app/core/constants/app_keys.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';
import 'package:ico_story_app/core/widgets/background_container.dart';
import 'package:ico_story_app/features/home/models/story_model.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/cubit/audio_cubit.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/story_reader_header.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/pdf_book_flip_local.dart';
import 'package:ico_story_app/features/home/widgets/story_reader/audio_controls.dart';

class StoryReaderView extends StatefulWidget {
  const StoryReaderView({required this.story, super.key, this.categoryId});
  final StoryModel story;
  final String? categoryId;

  @override
  State<StoryReaderView> createState() => _StoryReaderViewState();
}

class _StoryReaderViewState extends State<StoryReaderView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AudioCubit? _audioCubit;
  late AnimationController _waveController;
  bool _showAudioControls = false;
  final Alignment _pageAlignment = Alignment.center;
  bool _isPdfLoaded = false;

  bool get _isSurah => widget.categoryId == AppKeys.sira;
  String? get _storyTypeLabel {
    if (_isSurah) return null;
    if (widget.categoryId == AppKeys.tarbawia) return AppStrings.storyTypeNasheed;
    if (widget.categoryId == AppKeys.char) return AppStrings.storyTypeQissa;
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCubit();
    _initializeAnimations();
  }

  void _initializeCubit() {
    if (!_isSurah) {
      _audioCubit = AudioCubit(
        audioAssetPath: widget.story.audioPath ?? '',
      );
      _audioCubit!.initialize();
    }
  }

  void _initializeAnimations() {
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  void _onPdfLoaded() {
    if (mounted) {
      setState(() {
        _isPdfLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _audioCubit?.close();
    _waveController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _audioCubit?.handleAppLifecyclePause();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final audioContent = _audioCubit != null
        ? BlocProvider<AudioCubit>.value(
            value: _audioCubit!,
            child: _buildContent(),
          )
        : _buildContent();

    return audioContent;
  }

  Widget _buildContent() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundContainer(
        color: AppColors.primary,
        child: Column(
          children: [
            if (_isPdfLoaded)
              StoryReaderHeader(
                storyTitle: widget.story.title,
                onAudioToggle: _isSurah
                    ? null
                    : () => setState(() {
                        _showAudioControls = !_showAudioControls;
                      }),
                storyType: _storyTypeLabel,
                isAudioVisible: _showAudioControls && !_isSurah,
              ),
            Expanded(
              child: ColoredBox(
                color: AppColors.cardBackground,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PdfBookFlipLocal(
                        alignment: _pageAlignment,
                        pdfPath: widget.story.pdfPath,
                        onPdfLoaded: _onPdfLoaded,
                      ),
                    ),
                    if (!_isPdfLoaded)
                      const Positioned.fill(
                        child: ColoredBox(
                          color: AppColors.primary,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.cardBackground,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ),
                    if (_isPdfLoaded && _showAudioControls && !_isSurah)
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AudioControls(
                          categoryColor: AppColors.soundBackground,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
