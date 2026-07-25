class StoryModel {
  const StoryModel({
    required this.id,
    required this.title,
    required this.pdfPath,
    required this.coverImage,
    this.audioPath,
  });
  final String id;
  final String title;
  final String pdfPath;
  final String? audioPath;
  final String coverImage;
}
