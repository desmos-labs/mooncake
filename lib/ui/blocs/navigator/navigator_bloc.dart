import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

/// BloC that controls the navigation to the different screens of the app.
class NavigatorBloc extends Bloc<NavigatorEvent, void> {
  final GlobalKey<NavigatorState> _navigatorKey = PostsKeys.navigatorKey;
  final CheckLoginUseCase _checkLoginUseCase;

  NavigatorBloc({
    @required CheckLoginUseCase checkLoginUseCase,
  })  : assert(checkLoginUseCase != null),
        _checkLoginUseCase = checkLoginUseCase;

  factory NavigatorBloc.create() {
    return NavigatorBloc(
      checkLoginUseCase: Injector.get(),
    );
  }

  @override
  void get initialState => null;

  @override
  Stream<void> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigateToHome) {
      _mapNavigateToHomeEventToState();
    } else if (event is NavigateToRecoverAccount) {
      _mapNavigateToRecoverAccountEventToState();
    } else if (event is NavigateToEnableBiometrics) {
      _mapNavigateToBiometricScreenEventToState();
    } else if (event is NavigateToSetPassword) {
      _mapNavigateToPasswordScreenEventToState();
    } else if (event is NavigateToPostDetails) {
      _mapNavigateToPostDetailsEventToState(event);
    } else if (event is NavigateToWallet) {
      _mapNavigateToWalletEventToState();
    }
  }

  void _mapNavigateToHomeEventToState() {
    _navigatorKey.currentState.pushNamedAndRemoveUntil(
      PostsRoutes.home,
      (_) => false,
    );
  }

  void _mapNavigateToRecoverAccountEventToState() {
    _navigatorKey.currentState.pushNamed(PostsRoutes.recoverAccount);
  }

  void _mapNavigateToBiometricScreenEventToState() {
    _navigatorKey.currentState.push(MaterialPageRoute(
      builder: (context) => SetBiometricScreen(),
    ));
  }

  void _mapNavigateToPasswordScreenEventToState() {
    _navigatorKey.currentState.push(MaterialPageRoute(
      builder: (context) => SetPasswordScreen(),
    ));
  }

  void _mapNavigateToPostDetailsEventToState(
    NavigateToPostDetails event,
  ) async {
    final isLoggedIn = await _checkLoginUseCase.isLoggedIn();
    if (isLoggedIn) {
      _navigatorKey.currentState.push(MaterialPageRoute(
        builder: (context) => PostDetailsScreen(postId: event.postId),
      ));
    }
  }

  void _mapNavigateToWalletEventToState() {
    _navigatorKey.currentState.push(MaterialPageRoute(
      builder: (context) => WalletScreen(),
    ));
  }
}
