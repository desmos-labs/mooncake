import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Represents the bloc associated to the screen displaying the user's
/// account data.
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetAddressUseCase _getAddressUseCase;

  AccountBloc({@required GetAddressUseCase getAddressUseCase})
      : assert(getAddressUseCase != null),
        _getAddressUseCase = getAddressUseCase;

  factory AccountBloc.create() => AccountBloc(
        getAddressUseCase: Injector.get(),
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
    _getAddressUseCase.get().then((address) {
      add(AddressLoaded(address));
    });
  }

  Stream<AccountState> _mapAddressLoadedEventToState(
    AddressLoaded event,
  ) async* {
    yield (AccountLoaded(address: event.address));
  }
}
