import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'export.dart';

/// Represents the Bloc that handles the event for the mnemonic backup restore.
class RestoreBackupBloc extends Bloc<RestoreBackupEvent, RestoreBackupState> {
  final NavigatorBloc _navigatorBloc;
  final RecoverAccountBloc _recoverAccountBloc;

  final DecryptMnemonicUseCase _decryptMnemonicUseCase;

  RestoreBackupBloc({
    @required NavigatorBloc navigatorBloc,
    @required RecoverAccountBloc recoverAccountBloc,
    @required DecryptMnemonicUseCase decryptMnemonicUseCase,
  })  : assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(recoverAccountBloc != null),
        _recoverAccountBloc = recoverAccountBloc,
        assert(decryptMnemonicUseCase != null),
        _decryptMnemonicUseCase = decryptMnemonicUseCase,
        super(RestoreBackupState.initial());

  factory RestoreBackupBloc.create(BuildContext context) {
    return RestoreBackupBloc(
      navigatorBloc: BlocProvider.of(context),
      recoverAccountBloc: BlocProvider.of(context),
      decryptMnemonicUseCase: Injector.get(),
    );
  }

  @override
  Stream<RestoreBackupState> mapEventToState(RestoreBackupEvent event) async* {
    if (event is BackupTextChanged) {
      yield state.copyWith(backup: event.backup);
    } else if (event is EncryptPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is RestoreBackup) {
      yield* _mapRestoreBackupEventToState();
    }
  }

  Stream<RestoreBackupState> _mapRestoreBackupEventToState() async* {
    yield state.copyWith(restoring: true);

    final jsonData = jsonDecode(utf8.decode(base64Decode(state.backup)));
    final data = MnemonicData.fromJson(jsonData as Map<String, dynamic>);
    final password = state.password;
    final mnemonic = await _decryptMnemonicUseCase.decrypt(data, password);

    if (mnemonic == null) {
      // The mnemonic is invalid, which means that the password was not valid
      yield state.copyWith(isPasswordValid: false);
      return;
    }

    mnemonic.forEach((word) => _recoverAccountBloc.add(WordSelected(word)));
    _navigatorBloc.add(NavigateToProtectAccount());
  }
}
