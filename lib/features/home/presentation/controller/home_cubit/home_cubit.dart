import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ico_story_app/features/home/data/models/story_category_model.dart';
import 'package:ico_story_app/features/home/data/models/story_model.dart';
import 'package:ico_story_app/features/home/data/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.repository}) : super(HomeInitial());

  final HomeRepository repository;

  void getCategories() {
    try {
      emit(HomeLoading());
      final categories = repository.getCategories();
      emit(HomeCategoriesLoaded(categories));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void getStoriesForCategory(String categoryId) {
    try {
      emit(HomeLoading());
      final stories = repository.getStoriesForCategory(categoryId);
      emit(HomeStoriesLoaded(stories));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
