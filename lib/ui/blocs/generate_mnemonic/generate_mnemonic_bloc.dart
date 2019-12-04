import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/ui/ui.dart';
import 'package:desmosdemo/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Represents the bloc that handles event emitted while generating a new
/// mnemonic phrase and emits the proper statuses.
class GenerateMnemonicBloc
    extends Bloc<GenerateMnemonicEvent, GenerateMnemonicState> {
  final NavigatorBloc _navigatorBloc;
  final GenerateMnemonicUseCase _generateMnemonicUseCase;

  GenerateMnemonicBloc(
      {@required NavigatorBloc navigatorBloc,
      @required GenerateMnemonicUseCase generateMnemonicUseCase})
      : assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(generateMnemonicUseCase != null),
        _generateMnemonicUseCase = generateMnemonicUseCase;

  @override
  GenerateMnemonicState get initialState => GeneratingMnemonic();

  @override
  Stream<GenerateMnemonicState> mapEventToState(
    GenerateMnemonicEvent event,
  ) async* {
    if (event is GenerateMnemonic) {
      yield* _mapGenerateMnemonicEventToState();
    } else if (event is MnemonicWritten) {
      yield* _mapMnemonicWrittenEventToState();
    }
  }

  Stream<GenerateMnemonicState> _mapGenerateMnemonicEventToState() async* {
    yield GeneratingMnemonic();
    final mnemonic = await _generateMnemonicUseCase.generate();
    yield MnemonicGenerated(mnemonic);
  }

  Stream<GenerateMnemonicState> _mapMnemonicWrittenEventToState() async* {
    if (state is MnemonicGenerated) {
      final mnemonic = (state as MnemonicGenerated).mnemonic;
      final args = RecoverAccountArguments(mnemonic: mnemonic.join(" "));
      _navigatorBloc.add(NavigateToRecoverAccount(args: args));
    }
  }
}
