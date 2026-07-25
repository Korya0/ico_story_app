import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/constants/app_keys.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/router/app_transitions.dart';
import 'package:ico_story_app/core/services/pref_keys.dart';
import 'package:ico_story_app/core/services/shared_pref.dart';
import 'package:ico_story_app/features/home/models/story_model.dart';
import 'package:ico_story_app/features/home/views/home_view.dart';
import 'package:ico_story_app/features/home/views/stories_list_view.dart';
import 'package:ico_story_app/features/home/views/story_reader_screen.dart';
import 'package:ico_story_app/features/onboarding/views/onboarding_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: SharedPref().getBoolean(PrefKeys.showOnboarding) ?? false
        ? AppRoutes.home
        : AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        pageBuilder: (context, state) => naturalTransition(
          state: state,
          child: const OnboardingView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        pageBuilder: (context, state) => naturalTransition(
          state: state,
          child: const HomeView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.storiesList,
        name: AppRoutes.storiesList,
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          return naturalTransition(
            state: state,
            child: StoriesListView(
              categoryTitle: extras![AppKeys.categoryTitle] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.storyReader,
        name: AppRoutes.storyReader,
        pageBuilder: (context, state) {
          final extras = state.extra! as Map<String, dynamic>;
          final story = extras['story'] as StoryModel;
          final categoryId = extras['categoryId'] as String?;
          return naturalTransition(
            state: state,
            child: StoryReaderView(story: story, categoryId: categoryId),
          );
        },
      ),
    ],
  );
}
