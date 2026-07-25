import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/constants/app_keys.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/features/home/data/datasources/story_categories_list.dart';
import 'package:ico_story_app/features/home/presentation/widgets/home_view/home_story_card.dart';

class StoriesCardsWidget extends StatelessWidget {
  const StoriesCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = StoryCategoriesList.categories;
    return Column(
      spacing: 24,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: categories.take(2).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;

            return index == 0
                ? AppAnimations.fadeInRight(
                    HomeStoryCard(
                      imagePath: category.imagePath,
                      title: category.title,
                      onTap: () => context.pushNamed(
                        AppRoutes.storiesList,
                        extra: {AppKeys.categoryTitle: category.id},
                      ),
                    ),
                    delay: const Duration(milliseconds: 1000),
                  )
                : AppAnimations.fadeInLeft(
                    HomeStoryCard(
                      imagePath: category.imagePath,
                      title: category.title,
                      onTap: () => context.pushNamed(
                        AppRoutes.storiesList,
                        extra: {AppKeys.categoryTitle: category.id},
                      ),
                    ),
                    delay: const Duration(milliseconds: 1000),
                  );
          }).toList(),
        ),
        AppAnimations.fadeInUp(
          HomeStoryCard(
            imagePath: categories[2].imagePath,
            title: categories[2].title,
            onTap: () => context.pushNamed(
              AppRoutes.storiesList,
              extra: {AppKeys.categoryTitle: categories[2].id},
            ),
          ),
          delay: const Duration(milliseconds: 1300),
        ),
      ],
    );
  }
}
