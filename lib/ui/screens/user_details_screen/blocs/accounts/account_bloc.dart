import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';
import './export.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final AccountBloc _loginBloc;
  final GetAccountsUseCase _getAccountsUseCase;

  AccountsBloc({
    @required AccountBloc loginBloc,
    @required GetAccountsUseCase getAccountsUseCase,
  })  : assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(getAccountsUseCase != null),
        _getAccountsUseCase = getAccountsUseCase;

  factory AccountsBloc.create(BuildContext context) {
    return AccountsBloc(
      loginBloc: BlocProvider.of(context),
      getAccountsUseCase: Injector.get(),
    );
  }

  @override
  AccountsState get initialState {
    return AccountsState.initial();
  }

  @override
  Stream<AccountsState> mapEventToState(AccountsEvent event) async* {
    if (event is GetAccounts) {
      yield* _mapGetAccountsToState();
    }
  }

  Stream<AccountsState> _mapGetAccountsToState() async* {
    final List<MooncakeAccount> accounts = await _getAccountsUseCase.all();
    yield state.copyWith(accounts: accounts);
  }
}
