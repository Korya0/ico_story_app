import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:page_flip/page_flip.dart';
import 'package:pdfx/pdfx.dart';

class PdfBookFlipLocal extends StatefulWidget {
  const PdfBookFlipLocal({
    required this.pdfPath,
    super.key,
    this.alignment = Alignment.center,
    this.onPdfLoaded,
  });

  final String pdfPath;
  final Alignment alignment;
  final VoidCallback? onPdfLoaded;

  @override
  State<PdfBookFlipLocal> createState() => _PdfBookFlipLocalState();
}

class _PdfBookFlipLocalState extends State<PdfBookFlipLocal> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  List<Image> pages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _loadPages();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _loadPages() async {
    try {
      final doc = await PdfDocument.openAsset(widget.pdfPath);

      for (var i = 1; i <= doc.pagesCount; i++) {
        final page = await doc.getPage(i);

        final pageImage = await page.render(
          width: page.width * 0.7,
          height: page.height * 2,
        );

        if (pageImage != null) {
          pages.add(Image.memory(pageImage.bytes));
        }

        await page.close();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        widget.onPdfLoaded?.call();
      }
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || pages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: SizedBox.expand(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(3.141592653589793),
          child: PageFlipWidget(
            key: _controller,
            children: pages.map((img) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.141592653589793),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppColors.cardBackground,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image(
                            image: img.image,
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: double.infinity,
                            alignment: widget.alignment,
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: IgnorePointer(
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.primary.withValues(alpha: 0.3),
                                      AppColors.primary.withValues(alpha: 0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
