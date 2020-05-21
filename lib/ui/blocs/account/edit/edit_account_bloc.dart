import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';
import './bloc.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  final MooncakeAccount _account;
  final SaveAccountUseCase _saveAccountUseCase;

  EditAccountBloc({
    @required MooncakeAccount account,
    @required SaveAccountUseCase saveAccountUseCase,
  })  : assert(account != null),
        _account = account,
        assert(saveAccountUseCase != null),
        _saveAccountUseCase = saveAccountUseCase;

  factory EditAccountBloc.create(BuildContext context) {
    return EditAccountBloc(
      account: (BlocProvider.of<AccountBloc>(context).state as LoggedIn).user,
      saveAccountUseCase: Injector.get(),
    );
  }

  @override
  EditAccountState get initialState {
    return EditAccountState.initial(_account);
  }

  String _firstOrSecond(String first, String second) {
    return (first != null && first.trim().isNotEmpty) ? first : second;
  }

  @override
  Stream<EditAccountState> mapEventToState(EditAccountEvent event) async* {
    if (event is CoverChanged) {
      yield state.updateAccount(
        coverPicUrl:
            _firstOrSecond(event.cover.absolute.path, _account.coverPicUrl),
      );
    } else if (event is ProfilePicChanged) {
      yield state.updateAccount(
        profilePicUrl: _firstOrSecond(
            event.profilePic.absolute.path, _account.profilePicUrl),
      );
    } else if (event is MonikerChanged) {
      yield state.updateAccount(
        moniker: _firstOrSecond(event.moniker, _account.moniker),
      );
    } else if (event is NameChanged) {
      yield state.updateAccount(
        name: _firstOrSecond(event.name, _account.name),
      );
    } else if (event is SurnameChanged) {
      yield state.updateAccount(
        surname: _firstOrSecond(event.surname, _account.surname),
      );
    } else if (event is BioChanged) {
      yield state.updateAccount(
        bio: _firstOrSecond(event.bio, _account.bio),
      );
    } else if (event is SaveAccount) {
      yield* _handleSaveAccount();
    }
  }

  Stream<EditAccountState> _handleSaveAccount() async* {
    yield state.copyWith(saving: true);
    final account = state.account;
    print(account);
    await _saveAccountUseCase.save(state.account);
    yield state.copyWith(saving: false);
  }
}
