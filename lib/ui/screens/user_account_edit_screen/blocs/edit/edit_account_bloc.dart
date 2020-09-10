import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'export.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  final MooncakeAccount _account;
  final NavigatorBloc _navigatorBloc;

  final SaveAccountUseCase _saveAccountUseCase;

  EditAccountBloc({
    @required MooncakeAccount account,
    @required NavigatorBloc navigatorBloc,
    @required SaveAccountUseCase saveAccountUseCase,
  })  : assert(account != null),
        _account = account,
        assert(navigatorBloc != null),
        _navigatorBloc = navigatorBloc,
        assert(saveAccountUseCase != null),
        _saveAccountUseCase = saveAccountUseCase,
        super(EditAccountState.initial(account));

  factory EditAccountBloc.create(BuildContext context) {
    return EditAccountBloc(
      account: (BlocProvider.of<AccountBloc>(context).state as LoggedIn).user,
      navigatorBloc: BlocProvider.of(context),
      saveAccountUseCase: Injector.get(),
    );
  }

  String _firstOrSecond(String first, String second) {
    return (first != null && first.trim().isNotEmpty) ? first : second;
  }

  String _firstOrNull(String first, String second) {
    return (first != null && first.trim().isNotEmpty) ? first : null;
  }

  @override
  Stream<EditAccountState> mapEventToState(EditAccountEvent event) async* {
    if (event is CoverChanged) {
      yield* _mapCoverChangedToState(event);
    } else if (event is ProfilePicChanged) {
      yield* _mapProfilePicChangedToState(event);
    } else if (event is DTagChanged) {
      yield* _mapDTagChangedToState(event);
    } else if (event is MonikerChanged) {
      yield* _mapMonikerChangedToState(event);
    } else if (event is BioChanged) {
      yield* _mapBioChangedToState(event);
    } else if (event is SaveAccount) {
      yield* _handleSaveAccount();
    } else if (event is HideErrorPopup) {
      yield state.copyWith(showErrorPopup: false);
    }
  }

  Stream<EditAccountState> _mapCoverChangedToState(
    CoverChanged event,
  ) async* {
    final pic = _firstOrSecond(event.cover.absolute.path, _account.coverPicUri);
    yield state.updateAccount(coverPicUrl: pic);
  }

  Stream<EditAccountState> _mapProfilePicChangedToState(
    ProfilePicChanged event,
  ) async* {
    final pic = _firstOrSecond(
      event.profilePic.absolute.path,
      _account.profilePicUri,
    );
    yield state.updateAccount(profilePicUrl: pic);
  }

  Stream<EditAccountState> _mapDTagChangedToState(
    DTagChanged event,
  ) async* {
    final dtag = _firstOrSecond(event.dtag, _account.dtag);
    yield state.updateAccount(dtag: dtag);
  }

  Stream<EditAccountState> _mapMonikerChangedToState(
    MonikerChanged event,
  ) async* {
    final moniker = _firstOrSecond(event.moniker, _account.moniker);
    yield state.updateAccount(moniker: moniker);
  }

  Stream<EditAccountState> _mapBioChangedToState(
    BioChanged event,
  ) async* {
    final bio = _firstOrNull(event.bio, _account.bio);
    yield state.updateAccount(bio: bio);
  }

  Stream<EditAccountState> _handleSaveAccount() async* {
    // Set the state as saving
    yield state.copyWith(saving: true);

    // trim spaces
    final formattedAccount = state.account.copyWith(
      dtag: state.account.dtag.trim(),
      moniker: state.account.moniker.trim(),
      bio: state.account.bio?.trim(),
    );

    // Save the account
    final result = await _saveAccountUseCase.save(
      formattedAccount,
      syncRemote: true,
    );

    // Set back the state
    yield state.copyWith(
      saving: false,
      savingError: result.error,
      showErrorPopup: !result.success,
    );

    if (result.success) {
      _navigatorBloc.add(GoBack());
    }
  }
}
