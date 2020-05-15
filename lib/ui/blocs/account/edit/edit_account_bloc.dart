import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  EditAccountBloc();

  factory EditAccountBloc.create() {
    return EditAccountBloc();
  }

  @override
  EditAccountState get initialState => EditAccountState.initial();

  @override
  Stream<EditAccountState> mapEventToState(EditAccountEvent event) async* {
    // TODO: Add Logic
  }
}
