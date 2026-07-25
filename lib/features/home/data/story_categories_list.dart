import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/constants/app_keys.dart';
import 'package:ico_story_app/features/home/models/story_category_model.dart';

class StoryCategoriesList {
  static List<StoryCategoryModel> get categories => [
    StoryCategoryModel(
      id: AppKeys.char,
      title: 'قصص الحروف',
      imagePath: AppAssets.charsStories,
    ),
    StoryCategoryModel(
      id: AppKeys.tarbawia,
      title: 'كنوز القيم',
      imagePath: AppAssets.knoozStories,
    ),
    StoryCategoryModel(
      id: AppKeys.sira,
      title: 'قصص السيرة النبوية',
      imagePath: AppAssets.serahStories,
    ),
  ];
}
