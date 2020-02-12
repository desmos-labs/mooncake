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

/// Represents the bloc that handles event emitted while generating a new
/// mnemonic phrase and emits the proper statuses.
class GenerateMnemonicBloc
    extends Bloc<GenerateMnemonicEvent, GenerateMnemonicState> {
  final NavigatorBloc _navigatorBloc;
  final GenerateMnemonicUseCase _generateMnemonicUseCase;
  final FirebaseAnalytics _analytics;

  GenerateMnemonicBloc({
    @required NavigatorBloc navigatorBloc,
    @required GenerateMnemonicUseCase generateMnemonicUseCase,
    @required FirebaseAnalytics analytics,
  })  : assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(generateMnemonicUseCase != null),
        _generateMnemonicUseCase = generateMnemonicUseCase,
        assert(analytics != null),
        _analytics = analytics;

  factory GenerateMnemonicBloc.create(BuildContext context) {
    return GenerateMnemonicBloc(
      navigatorBloc: BlocProvider.of(context),
      generateMnemonicUseCase: Injector.get(),
      analytics: Injector.get(),
    );
  }

  @override
  GenerateMnemonicState get initialState => GeneratingMnemonic();

  @override
  Stream<GenerateMnemonicState> mapEventToState(
    GenerateMnemonicEvent event,
  ) async* {
    if (event is GenerateMnemonic) {
      _analytics.logEvent(name: Constants.EVENT_MNEMONIC_GENERATE);
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
