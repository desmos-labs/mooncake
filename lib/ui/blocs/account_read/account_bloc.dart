import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Handles the login events and emits the proper state instances.
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  static const SETTING_FIRST_START = "first_start";

  final FirebaseAnalytics _analytics;

  final GenerateMnemonicUseCase _generateMnemonicUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetAccountUseCase _getUserUseCase;
  final RefreshAccountUseCase _refreshAccountUseCase;
  final GetSettingUseCase _getSettingUseCase;
  final SaveSettingUseCase _saveSettingUseCase;

  final NavigatorBloc _navigatorBloc;

  StreamSubscription _accountSubscription;

  AccountBloc({
    @required GenerateMnemonicUseCase generateMnemonicUseCase,
    @required LogoutUseCase logoutUseCase,
    @required GetAccountUseCase getUserUseCase,
    @required RefreshAccountUseCase refreshAccountUseCase,
    @required GetSettingUseCase getSettingUseCase,
    @required SaveSettingUseCase saveSettingUseCase,
    @required NavigatorBloc navigatorBloc,
    @required FirebaseAnalytics analytics,
  })  : assert(generateMnemonicUseCase != null),
        _generateMnemonicUseCase = generateMnemonicUseCase,
        assert(logoutUseCase != null),
        _logoutUseCase = logoutUseCase,
        assert(getUserUseCase != null),
        _getUserUseCase = getUserUseCase,
        assert(refreshAccountUseCase != null),
        _refreshAccountUseCase = refreshAccountUseCase,
        assert(getSettingUseCase != null),
        _getSettingUseCase = getSettingUseCase,
        assert(saveSettingUseCase != null),
        _saveSettingUseCase = saveSettingUseCase,
        assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(analytics != null),
        _analytics = analytics {
    // Listen for account changes so that we know when to refresh
    _accountSubscription = _getUserUseCase.stream().listen((account) {
      add(UserRefreshed(account));
    });
  }

  factory AccountBloc.create(BuildContext context) {
    return AccountBloc(
      generateMnemonicUseCase: Injector.get(),
      logoutUseCase: Injector.get(),
      getUserUseCase: Injector.get(),
      refreshAccountUseCase: Injector.get(),
      getSettingUseCase: Injector.get(),
      saveSettingUseCase: Injector.get(),
      navigatorBloc: BlocProvider.of(context),
      analytics: Injector.get(),
    );
  }

  @override
  AccountState get initialState => Loading();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is CheckStatus) {
      yield* _mapCheckStatusEventToState();
    } else if (event is GenerateAccount) {
      yield* _mapGenerateAccountEventToState();
    } else if (event is LogIn) {
      yield* _mapLogInEventToState(event);
    } else if (event is LogOut) {
      yield* _mapLogOutEventToState();
    } else if (event is UserRefreshed) {
      yield* _mapRefreshEventToState(event);
    } else if (event is RefreshAccount) {
      yield* _mapRefreshAccountEventToState();
    }
  }

  /// Checks the current user state, determining if it is logged in or not.
  /// After the check, either [LoggedIn] or [LoggedOut] are emitted.
  Stream<AccountState> _mapCheckStatusEventToState() async* {
    // Remove any info if it's the first start
    final firstStart = await _getSettingUseCase.get(key: SETTING_FIRST_START);
    if (firstStart as bool ?? true) {
      await _logoutUseCase.logout();
      await _saveSettingUseCase.save(key: SETTING_FIRST_START, value: false);
    }

    final account = await _getUserUseCase.single();
    if (account != null) {
      await _analytics.setUserId(account.address);
      await _analytics.logLogin();
      yield LoggedIn.initial(account);
    } else {
      yield LoggedOut();
    }
  }

  /// Handle the [GenerateAccount] event, which is emitted when the user wants
  /// to create a new account. It creates a new account, stores it locally
  /// and later yield the [LoggedIn] state.
  Stream<AccountState> _mapGenerateAccountEventToState() async* {
    yield CreatingAccount();
    final mnemonic = await _generateMnemonicUseCase.generate();
    yield AccountCreated(mnemonic);
  }

  /// Handle the [LogIn] event, emitting the [LoggedIn] state as well
  /// as sending the user to the Home screen.
  Stream<AccountState> _mapLogInEventToState(LogIn event) async* {
    final account = await _getUserUseCase.single();
    yield LoggedIn.initial(account);
    _navigatorBloc.add(NavigateToHome());
  }

  /// Handles the [LogOut] event emitting the [LoggedOut] state after
  /// effectively logging out the user.
  Stream<AccountState> _mapLogOutEventToState() async* {
    await _analytics.logEvent(name: Constants.EVENT_LOGOUT);
    await _logoutUseCase.logout();
    yield LoggedOut();
  }

  /// Handles the event emitted when the user has triggered a manual refresh
  /// of the account details.
  Stream<AccountState> _mapRefreshAccountEventToState() async* {
    final currentState = state;
    if (currentState is LoggedIn) {
      yield currentState.copyWith(refreshing: true);
      await _refreshAccountUseCase.refresh();
      yield currentState.copyWith(refreshing: false);
    }
  }

  /// Handles the event that is emitted when the user details have been
  /// changed and they should be refreshed.
  Stream<AccountState> _mapRefreshEventToState(UserRefreshed event) async* {
    final currentState = state;
    if (currentState is LoggedIn) {
      yield currentState.copyWith(user: event.user, refreshing: false);
    }
  }

  @override
  Future<void> close() {
    _accountSubscription?.cancel();
    return super.close();
  }
}
