import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dwitter/dependency_injection/dependency_injection.dart';
import 'package:dwitter/ui/ui.dart';
import 'package:dwitter/usecases/usecases.dart';
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
    }
  }

  Stream<AccountState> _mapLoadAccountEventToState() async* {
    // Load the data
    final address = await _getAddressUseCase.get();
    yield AccountLoaded(
      address: address,
    );
  }
}
