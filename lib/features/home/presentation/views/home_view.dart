import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ico_story_app/core/widgets/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/features/home/data/repositories/home_repository.dart';
import 'package:ico_story_app/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:ico_story_app/features/home/presentation/widgets/home_view/home_header_section.dart';
import 'package:ico_story_app/features/home/presentation/widgets/home_view/social_button.dart';
import 'package:ico_story_app/features/home/presentation/widgets/home_view/stories_card_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return BlocProvider(
      create: (context) => HomeCubit(repository: HomeRepository())..getCategories(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Gap(isTablet ? 10 : 40),
                const HomeHeaderSection(),
                Gap(isTablet ? 40 : 20),
                const StoriesCardsWidget(),
                Gap(isTablet ? 40 : 20),
                const SocialButton(),
                Gap(isTablet ? 10 : 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
