import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/features/home/helpers/function.dart';
import 'package:ico_story_app/features/home/widgets/stories_list/stories_list_header.dart';
import 'package:ico_story_app/features/home/widgets/stories_list/stories_list_section.dart';

class StoriesListView extends StatelessWidget {
  const StoriesListView({required this.categoryTitle, super.key});
  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Scaffold(
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
    );
  }
}
