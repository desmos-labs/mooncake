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

import 'export.dart';

/// Represents the Bloc that is used when wanting to display the mnemonic
/// to the user.
class MnemonicBloc extends Bloc<MnemonicEvent, MnemonicState> {
  final FirebaseAnalytics _analytics;

  final NavigatorBloc _navigatorBloc;

  final GetMnemonicUseCase _getMnemonicUseCase;
  final EncryptMnemonicUseCase _encryptMnemonicUseCase;

  MnemonicBloc({
    @required NavigatorBloc navigatorBloc,
    @required GetMnemonicUseCase getMnemonicUseCase,
    @required EncryptMnemonicUseCase encryptMnemonicUseCase,
    @required FirebaseAnalytics analytics,
  })  : assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(getMnemonicUseCase != null),
        _getMnemonicUseCase = getMnemonicUseCase,
        assert(encryptMnemonicUseCase != null),
        _encryptMnemonicUseCase = encryptMnemonicUseCase,
        assert(analytics != null),
        _analytics = analytics,
        super(MnemonicState.initial());

  factory MnemonicBloc.create(BuildContext context) {
    return MnemonicBloc(
      navigatorBloc: BlocProvider.of(context),
      getMnemonicUseCase: Injector.get(),
      encryptMnemonicUseCase: Injector.get(),
      analytics: Injector.get(),
    );
  }

  @override
  Stream<MnemonicState> mapEventToState(MnemonicEvent event) async* {
    if (event is ToggleCheckBox) {
      yield* _mapToggleCheckBoxToState();
    } else if (event is ShowMnemonic) {
      yield* _mapShowMnemonicEventToState(event);
    } else if (event is ShowExportPopup) {
      yield ExportingMnemonic.fromMnemonicState(state);
    } else if (event is ChangeEncryptPassword) {
      yield* _mapEncryptPasswordChangedToState(event);
    } else if (event is CloseExportPopup) {
      yield* _mapCloseExportPopupEventToState();
    } else if (event is ExportMnemonic) {
      yield* _mapExportMnemonicEventToState();
    }
  }

  Stream<MnemonicState> _mapToggleCheckBoxToState() async* {
    yield state.copyWith(hasCheckedBox: !state.hasCheckedBox);
  }

  Stream<MnemonicState> _mapShowMnemonicEventToState(
      ShowMnemonic event) async* {
    final mnemonic = await _getMnemonicUseCase.get(event.address);
    yield state.copyWith(showMnemonic: true, mnemonic: mnemonic);
  }

  Stream<MnemonicState> _mapEncryptPasswordChangedToState(
    ChangeEncryptPassword event,
  ) async* {
    final currentState = state;
    if (currentState is ExportingMnemonic) {
      yield currentState.copyWith(encryptPassword: event.password);
    }
  }

  Stream<MnemonicState> _mapExportMnemonicEventToState() async* {
    final currentState = state;
    if (currentState is ExportingMnemonic) {
      yield currentState.copyWith(exportingMnemonic: true);

      // Encrypt the mnemonic
      final mnemonicData = await _encryptMnemonicUseCase.encrypt(
        currentState.mnemonic,
        currentState.encryptPassword,
      );

      // Close the popup
      yield* _mapCloseExportPopupEventToState();

      // Go to the page where the exported data can be shared
      await _analytics.logEvent(name: Constants.EVENT_MNEMONIC_EXPORT);
      _navigatorBloc.add(NavigateToExportMnemonic(mnemonicData: mnemonicData));
    }
  }

  Stream<MnemonicState> _mapCloseExportPopupEventToState() async* {
    yield MnemonicState(
      mnemonic: state.mnemonic,
      hasCheckedBox: state.hasCheckedBox,
      showMnemonic: state.showMnemonic,
    );
  }
}
