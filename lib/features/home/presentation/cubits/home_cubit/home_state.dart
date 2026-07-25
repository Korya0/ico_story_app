part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeCategoriesLoaded extends HomeState {
  HomeCategoriesLoaded(this.categories);

  final List<StoryCategoryModel> categories;
}

class HomeStoriesLoaded extends HomeState {
  HomeStoriesLoaded(this.stories);

  final List<StoryModel> stories;
}

class HomeError extends HomeState {
  HomeError(this.message);

  final String message;
}
