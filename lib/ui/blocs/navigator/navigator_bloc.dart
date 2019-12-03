import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/ui/ui.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, void> {
  final _navigatorKey = PostsKeys.navigatorKey;

  @override
  void get initialState => null;

  @override
  Stream<void> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigateToHome) {
      _navigatorKey.currentState.pushNamedAndRemoveUntil(
        PostsRoutes.home,
        (_) => false,
      );
    } else if (event is NavigateToRecoverAccount) {
      _navigatorKey.currentState.pushNamed(PostsRoutes.recoverAccount);
    }
  }
}
