// ignore_for_file: use_setters_to_change_properties

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFManager {
  PDFManager({
    required this.pdfAssetPath,
    required this.storyTitle,
    required this.onStateChanged,
  });
  final String pdfAssetPath;
  final String storyTitle;
  final VoidCallback onStateChanged;

  String? localPdfPath;
  int currentPage = 0;
  int totalPages = 0;
  bool pdfReady = false;
  PDFViewController? pdfViewController;

  Future<void> initialize() async {
    await _loadPdfFromAssets();
  }

  Future<void> _loadPdfFromAssets() async {
    try {
      final byteData = await rootBundle.load(pdfAssetPath);
      final file = File(
        '${(await getTemporaryDirectory()).path}/$storyTitle.pdf',
      );
      await file.writeAsBytes(byteData.buffer.asUint8List());

      localPdfPath = file.path;
      pdfReady = true;
      onStateChanged();
    } catch (e) {
      debugPrint('PDF loading error: $e');
    }
  }

  Future<void> nextPage() async {
    if (pdfViewController != null && currentPage < totalPages - 1) {
      await pdfViewController!.setPage(currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (pdfViewController != null && currentPage > 0) {
      await pdfViewController!.setPage(currentPage - 1);
    }
  }

  Future<void> goToFirstPage() async {
    if (pdfViewController != null) {
      await pdfViewController!.setPage(0);
    }
  }

  void onViewCreated(PDFViewController controller) {
    pdfViewController = controller;
  }

  void onRender(int? pages) {
    totalPages = pages ?? 0;
    onStateChanged();
  }

  void onPageChanged(int? page, int? total) {
    currentPage = page ?? 0;
    totalPages = total ?? 0;
    onStateChanged();
  }

  void dispose() {}
}
