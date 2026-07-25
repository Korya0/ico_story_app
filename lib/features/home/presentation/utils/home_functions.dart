import 'package:ico_story_app/core/constants/app_keys.dart';
import 'package:ico_story_app/core/constants/app_strings.dart';

String returnTitle(String categoryTitle) {
  switch (categoryTitle) {
    case AppKeys.char:
      return AppStrings.charsStories;
    case AppKeys.tarbawia:
      return AppStrings.knoozStories;
    case AppKeys.sira:
      return AppStrings.serahStories;
    default:
      return AppStrings.defaultStories;
  }
}
