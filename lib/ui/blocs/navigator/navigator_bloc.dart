import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

/// BloC that controls the navigation to the different screens of the app.
class NavigatorBloc extends Bloc<NavigatorEvent, void> {
  final GlobalKey<NavigatorState> _navigatorKey = PostsKeys.navigatorKey;

  final CheckLoginUseCase _checkLoginUseCase;
  final CanUseBiometricsUseCase _canUseBiometricsUseCase;
  final GetAuthenticationMethodUseCase _getAuthenticationMethodUseCase;

  NavigatorBloc({
    @required CheckLoginUseCase checkLoginUseCase,
    @required CanUseBiometricsUseCase canUseBiometricsUseCase,
    @required GetAuthenticationMethodUseCase getAuthenticationMethodUseCase,
  })  : assert(checkLoginUseCase != null),
        _checkLoginUseCase = checkLoginUseCase,
        assert(canUseBiometricsUseCase != null),
        _canUseBiometricsUseCase = canUseBiometricsUseCase,
        assert(getAuthenticationMethodUseCase != null),
        _getAuthenticationMethodUseCase = getAuthenticationMethodUseCase;

  factory NavigatorBloc.create() {
    return NavigatorBloc(
      checkLoginUseCase: Injector.get(),
      canUseBiometricsUseCase: Injector.get(),
      getAuthenticationMethodUseCase: Injector.get(),
    );
  }

  @override
  void get initialState => null;

  @override
  Stream<void> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigateToHome) {
      _mapNavigateToHomeEventToState();
    } else if (event is NavigateToProtectAccount) {
      _mapNavigateToProtectAccountScreenEventToState();
    } else if (event is NavigateToRecoverAccount) {
      _mapNavigateToRecoverAccountEventToState();
    } else if (event is NavigateToEnableBiometrics) {
      _mapNavigateToBiometricScreenEventToState();
    } else if (event is NavigateToSetPassword) {
      _mapNavigateToPasswordScreenEventToState();
    } else if (event is NavigateToPostDetails) {
      _mapNavigateToPostDetailsEventToState(event);
    } else if (event is NavigateToCreatePost) {
      _mapNavigateToCreatePostEventToState(event);
    } else if (event is NavigateToWallet) {
      _mapNavigateToWalletEventToState();
    } else if (event is GoBack) {
      _handleGoBack(event);
    } else if (event is NavigateToShowMnemonic) {
      _handleNavigateToShowMnemonic();
    } else if (event is NavigateToEditAccount) {
      _handleNavigateToEditAccount();
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

  void _mapNavigateToProtectAccountScreenEventToState() async {
    final canUseBio = await _canUseBiometricsUseCase.check();
    if (canUseBio) {
      _mapNavigateToBiometricScreenEventToState();
    } else {
      _mapNavigateToPasswordScreenEventToState();
    }
  }

  void _mapNavigateToBiometricScreenEventToState() {
    _navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
      return SetBiometricScreen();
    }));
  }

  void _mapNavigateToPasswordScreenEventToState() {
    _navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
      return SetPasswordScreen();
    }));
  }

  void _mapNavigateToPostDetailsEventToState(
    NavigateToPostDetails event,
  ) async {
    final isLoggedIn = await _checkLoginUseCase.isLoggedIn();
    if (isLoggedIn) {
      _navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
        return BlocProvider<PostDetailsBloc>(
          create: (context) => PostDetailsBloc.create(context, event.postId),
          child: PostDetailsScreen(),
        );
      }));
    }
  }

  void _mapNavigateToCreatePostEventToState(NavigateToCreatePost event) {
    _navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
      return CreatePostScreen(parentPost: event.parentPost);
    }));
  }

  void _mapNavigateToWalletEventToState() {
    _navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
      return WalletScreen();
    }));
  }

  void _handleNavigateToShowMnemonic() async {
    final method = await _getAuthenticationMethodUseCase.get();
    if (method is BiometricAuthentication) {
      _navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
        return LoginWithBiometricsScreen();
      }));
    } else if (method is PasswordAuthentication) {
      _navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
        return LoginWithPasswordScreen(hashedPassword: method.hashedPassword);
      }));
    }
  }

  void _handleNavigateToEditAccount() async {
    _navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
      return EditAccountScreen();
    }));
  }

  void _handleGoBack(GoBack event) {
    _navigatorKey.currentState.pop(event.result);
  }
}
