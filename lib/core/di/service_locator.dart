import 'package:get_it/get_it.dart';
import 'package:ico_story_app/features/home/data/repositories/home_repository.dart';
import 'package:ico_story_app/features/home/presentation/controller/home_cubit/home_cubit.dart';

final sl = GetIt.instance;

late final HomeRepository _homeRepository;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<HomeRepository>(HomeRepository.new);
  _homeRepository = sl<HomeRepository>();

  sl.registerFactory<HomeCubit>(() => HomeCubit(repository: _homeRepository));
}