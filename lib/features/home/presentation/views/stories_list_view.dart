import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ico_story_app/core/di/service_locator.dart';
import 'package:ico_story_app/core/widgets/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/features/home/presentation/controller/home_cubit/home_cubit.dart';
import 'package:ico_story_app/features/home/presentation/utils/home_functions.dart';
import 'package:ico_story_app/features/home/presentation/widgets/stories_list/stories_list_header.dart';
import 'package:ico_story_app/features/home/presentation/widgets/stories_list/stories_list_section.dart';

class StoriesListView extends StatelessWidget {
  const StoriesListView({required this.categoryTitle, super.key});
  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return BlocProvider(
      create: (context) => sl<HomeCubit>()
        ..getStoriesForCategory(categoryTitle),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: Gap(50)),

              SliverToBoxAdapter(
                child: StoriesListHeader(
                  categoryTitle: returnTitle(categoryTitle),
                ),
              ),

              SliverToBoxAdapter(
                child: StoriesListSection(categoryTitle: categoryTitle),
              ),

              const SliverToBoxAdapter(child: Gap(20)),
            ],
          ),
        ),
      ),
    );
  }
}
