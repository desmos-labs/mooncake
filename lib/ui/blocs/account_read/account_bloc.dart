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
  static const SETTING_FIRST_START = 'first_start';

  final FirebaseAnalytics _analytics;

  final GenerateMnemonicUseCase _generateMnemonicUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetActiveAccountUseCase _getActiveAccountUseCase;
  final RefreshAccountUseCase _refreshAccountUseCase;
  final GetSettingUseCase _getSettingUseCase;
  final SaveSettingUseCase _saveSettingUseCase;
  final GetAccountsUseCase _getAccountsUseCase;
  final SetAccountActiveUsecase _setAccountActiveUsecase;
  final NavigatorBloc _navigatorBloc;

  StreamSubscription _accountSubscription;

  AccountBloc({
    @required GenerateMnemonicUseCase generateMnemonicUseCase,
    @required LogoutUseCase logoutUseCase,
    @required GetActiveAccountUseCase getActiveAccountUseCase,
    @required RefreshAccountUseCase refreshAccountUseCase,
    @required GetSettingUseCase getSettingUseCase,
    @required SaveSettingUseCase saveSettingUseCase,
    @required NavigatorBloc navigatorBloc,
    @required FirebaseAnalytics analytics,
    @required GetAccountsUseCase getAccountsUseCase,
    @required SetAccountActiveUsecase setAccountActiveUsecase,
  })  : assert(generateMnemonicUseCase != null),
        _generateMnemonicUseCase = generateMnemonicUseCase,
        assert(logoutUseCase != null),
        _logoutUseCase = logoutUseCase,
        assert(getActiveAccountUseCase != null),
        _getActiveAccountUseCase = getActiveAccountUseCase,
        assert(refreshAccountUseCase != null),
        _refreshAccountUseCase = refreshAccountUseCase,
        assert(getSettingUseCase != null),
        _getSettingUseCase = getSettingUseCase,
        assert(saveSettingUseCase != null),
        _saveSettingUseCase = saveSettingUseCase,
        assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(analytics != null),
        _analytics = analytics,
        assert(getAccountsUseCase != null),
        _getAccountsUseCase = getAccountsUseCase,
        assert(setAccountActiveUsecase != null),
        _setAccountActiveUsecase = setAccountActiveUsecase,
        super(Loading()) {
    // Listen for account changes so that we know when to refresh
    _accountSubscription = _getActiveAccountUseCase.stream().listen((account) {
      add(UserRefreshed(account));
    });
  }

  factory AccountBloc.create(BuildContext context) {
    return AccountBloc(
      generateMnemonicUseCase: Injector.get(),
      logoutUseCase: Injector.get(),
      getActiveAccountUseCase: Injector.get(),
      refreshAccountUseCase: Injector.get(),
      getSettingUseCase: Injector.get(),
      saveSettingUseCase: Injector.get(),
      navigatorBloc: BlocProvider.of(context),
      analytics: Injector.get(),
      getAccountsUseCase: Injector.get(),
      setAccountActiveUsecase: Injector.get(),
    );
  }

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is CheckStatus) {
      yield* _mapCheckStatusEventToState();
    } else if (event is GenerateAccount) {
      yield* _mapGenerateAccountEventToState();
    } else if (event is GenerateAccountWhileLoggedIn) {
      yield* _mapGenerateAccountEventToState();
    } else if (event is LogIn) {
      yield* _mapLogInEventToState(event);
    } else if (event is LogOut) {
      yield* _mapLogOutEventToState(event);
    } else if (event is UserRefreshed) {
      yield* _mapRefreshEventToState(event);
    } else if (event is RefreshAccount) {
      yield* _mapRefreshAccountEventToState();
    } else if (event is LogOutAll) {
      yield* _mapLogOutAllEventToState();
    } else if (event is GetAllAccounts) {
      yield* _mapGetAllAccountsEventToState();
    } else if (event is SwitchAccount) {
      yield* _mapSwitchAccountEventToState(event);
    }
  }

  /// Checks the current user state, determining if it is logged in or not.
  /// After the check, either [LoggedIn] or [LoggedOut] are emitted.
  Stream<AccountState> _mapCheckStatusEventToState() async* {
    // Remove any info if it's the first start
    final firstStart = await _getSettingUseCase.get(key: SETTING_FIRST_START);
    if (firstStart as bool ?? true) {
      await _logoutUseCase.logoutAll();
      await _saveSettingUseCase.save(key: SETTING_FIRST_START, value: false);
    }

    final account = await _getActiveAccountUseCase.single();
    if (account != null) {
      await _analytics.setUserId(account.address);
      await _analytics.logLogin();
      final storedAccounts = await _getAccountsUseCase.all();
      yield LoggedIn.initial(account, storedAccounts);
    } else {
      yield LoggedOut();
    }
  }

  /// Handle the [GenerateAccount] event, which is emitted when the user wants
  /// to create a new account. It creates a new account, stores it locally
  /// and later yield the [LoggedIn] state.
  Stream<AccountState> _mapGenerateAccountEventToState() async* {
    final currentState = state;

    if (currentState is LoggedIn) {
      yield CreatingAccountWhileLoggedIn(
        user: currentState.user,
        accounts: currentState.accounts,
        refreshing: currentState.refreshing,
      );
    } else {
      yield CreatingAccount();
    }

    final mnemonic = await _generateMnemonicUseCase.generate();
    await Future.delayed(const Duration(seconds: 2));

    var isAccountCreatedWhileLogginIn = false;
    if (currentState is LoggedIn) {
      isAccountCreatedWhileLogginIn = true;
      yield AccountCreatedWhileLoggedIn(
        mnemonic,
        user: currentState.user,
        accounts: currentState.accounts,
        refreshing: currentState.refreshing,
      );
    } else {
      yield AccountCreated(mnemonic);
    }

    if (isAccountCreatedWhileLogginIn) {
      _navigatorBloc.add(NavigateToProtectAccount());
    }
  }

  /// Handle the [LogIn] event, emitting the [LoggedIn] state as well
  /// as sending the user to the Home screen.
  Stream<AccountState> _mapLogInEventToState(LogIn event) async* {
    final account = await _getActiveAccountUseCase.single();
    final storedAccounts = await _getAccountsUseCase.all();
    yield LoggedIn.initial(account, storedAccounts);
    _navigatorBloc.add(NavigateToHome());
  }

  /// Handles the [LogOut] event emitting the [LoggedOut] state after
  /// effectively logging out the user.
  Stream<AccountState> _mapLogOutEventToState(LogOut event) async* {
    await _analytics.logEvent(name: Constants.EVENT_LOGOUT);
    await _logoutUseCase.logout(event.address);
    final account = await _getActiveAccountUseCase.single();
    if (account == null) {
      yield LoggedOut();
    } else {
      yield* _mapGetAllAccountsEventToState();
    }
  }

  /// Handles the [LogOutAll] event emitting the [LoggedOut] state after
  /// effectively logging out all user.
  Stream<AccountState> _mapLogOutAllEventToState() async* {
    await _analytics.logEvent(name: Constants.EVENT_LOGOUT);
    await _logoutUseCase.logoutAll();
    yield LoggedOut();
  }

  /// Handles the event emitted when the user has triggered a manual refresh
  /// of the account details.
  Stream<AccountState> _mapRefreshAccountEventToState() async* {
    final currentState = state;
    if (currentState is LoggedIn) {
      yield currentState.copyWith(refreshing: true);
      await _refreshAccountUseCase.refresh(currentState.user.address);
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

  /// Refreshes currently list of all stored accounts
  Stream<AccountState> _mapGetAllAccountsEventToState() async* {
    final currentState = state;
    if (currentState is LoggedIn) {
      final storedAccounts = await _getAccountsUseCase.all();
      yield LoggedIn.initial(currentState.user, storedAccounts);
    }
  }

  /// Switch accounts
  Stream<AccountState> _mapSwitchAccountEventToState(
    SwitchAccount event,
  ) async* {
    final currentState = state;
    if (currentState is LoggedIn) {
      await _setAccountActiveUsecase.setActive(event.user);
    }
  }

  @override
  Future<void> close() {
    _accountSubscription?.cancel();
    return super.close();
  }
}
