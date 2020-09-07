import 'package:bloc/bloc.dart';

/// Extension of [BlocObserver] that allows to debug all the events,
/// transactions and errors that might verify.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition.toString());
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    print(error.toString());
  }
}
