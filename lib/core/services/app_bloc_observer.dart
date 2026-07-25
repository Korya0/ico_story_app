import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ico_story_app/core/services/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.info('[Bloc Created] ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    final eventStr = event.toString();
    final truncatedEvent = eventStr.length > 200
        ? '${eventStr.substring(0, 200)}...'
        : eventStr;
    AppLogger.info('[Event] ${bloc.runtimeType} -> $truncatedEvent');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    final stateStr = change.nextState.toString();
    final truncatedState = stateStr.length > 200
        ? '${stateStr.substring(0, 200)}...'
        : stateStr;
    AppLogger.info('[State Change] ${bloc.runtimeType} -> $truncatedState');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(
      '[BlocError] ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    AppLogger.info('[Bloc Closed] ${bloc.runtimeType}');
  }
}
