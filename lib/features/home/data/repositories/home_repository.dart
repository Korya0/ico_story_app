import 'package:ico_story_app/features/home/data/models/story_category_model.dart';
import 'package:ico_story_app/features/home/data/models/story_model.dart';
import 'package:ico_story_app/features/home/data/datasources/story_categories_list.dart';
import 'package:ico_story_app/features/home/data/datasources/story_list.dart';

class HomeRepository {
  List<StoryCategoryModel> getCategories() {
    return StoryCategoriesList.categories;
  }

  List<StoryModel> getStoriesForCategory(String categoryId) {
    return StoryList.getStoriesForCategory(categoryId);
  }
}
