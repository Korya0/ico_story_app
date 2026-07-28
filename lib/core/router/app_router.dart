import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/constants/app_keys.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/services/local_storage/pref_keys.dart';
import 'package:ico_story_app/core/services/local_storage/shared_pref.dart';
import 'package:ico_story_app/features/home/data/models/story_model.dart';
import 'package:ico_story_app/features/home/presentation/views/home_view.dart';
import 'package:ico_story_app/features/home/presentation/views/stories_list_view.dart';
import 'package:ico_story_app/features/home/presentation/views/story_reader_screen.dart';
import 'package:ico_story_app/features/onboarding/presentation/views/onboarding_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: SharedPref().getBoolean(PrefKeys.showOnboarding) ?? false
        ? AppRoutes.home
        : AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.storiesList,
        name: AppRoutes.storiesList,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          return StoriesListView(
            categoryTitle: extras![AppKeys.categoryTitle] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.storyReader,
        name: AppRoutes.storyReader,
        builder: (context, state) {
          final extras = state.extra! as Map<String, dynamic>;
          final story = extras['story'] as StoryModel;
          final categoryId = extras['categoryId'] as String?;
          return StoryReaderView(story: story, categoryId: categoryId);
        },
      ),
    ],
  );
}
