import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/usecases/usecases.dart';
import './bloc.dart';

/// Represents the Bloc that is used when wanting to display the mnemonic
/// to the user.
class MnemonicBloc extends Bloc<MnemonicEvent, MnemonicState> {
  final GetMnemonicUseCase _getMnemonicUseCase;

  MnemonicBloc({
    @required GetMnemonicUseCase getMnemonicUseCase,
  })  : assert(getMnemonicUseCase != null),
        _getMnemonicUseCase = getMnemonicUseCase;

  factory MnemonicBloc.create() {
    return MnemonicBloc(
      getMnemonicUseCase: Injector.get(),
    );
  }

  @override
  MnemonicState get initialState => MnemonicState.initial();

  @override
  Stream<MnemonicState> mapEventToState(MnemonicEvent event) async* {
    if (event is ShowMnemonic) {
      yield* _mapShowMnemonicEventToState();
    }
  }

  Stream<MnemonicState> _mapShowMnemonicEventToState() async* {
    final mnemonic = await _getMnemonicUseCase.get();
    yield state.copyWith(showMnemonic: true, mnemonic: mnemonic);
  }
}
