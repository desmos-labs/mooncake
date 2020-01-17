import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Represents the bloc associated to the screen displaying the user's
/// account data.
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAccountUseCase _getAccountUseCase;

  AccountBloc({@required GetAccountUseCase getAccountUseCase})
      : assert(getAccountUseCase != null),
        _getAccountUseCase = getAccountUseCase;

  factory AccountBloc.create() => AccountBloc(
        getAccountUseCase: Injector.get(),
      );

  @override
  AccountState get initialState => LoadingAccount();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is LoadAccount) {
      yield* _mapLoadAccountEventToState();
    } else if (event is AddressLoaded) {
      yield* _mapAddressLoadedEventToState(event);
    }
  }

  Stream<AccountState> _mapLoadAccountEventToState() async* {
    // Load the data
    _getAccountUseCase.get().then((account) {
      add(AddressLoaded(account));
    });
  }

  Stream<AccountState> _mapAddressLoadedEventToState(
    AddressLoaded event,
  ) async* {
    yield (AccountLoaded(account: event.account));
  }
}
