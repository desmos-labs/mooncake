import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';
import './bloc.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  final SaveAccountUseCase _saveAccountUseCase;

  EditAccountBloc({
    @required SaveAccountUseCase saveAccountUseCase,
  })  : assert(saveAccountUseCase != null),
        _saveAccountUseCase = saveAccountUseCase;

  factory EditAccountBloc.create() {
    return EditAccountBloc(
      saveAccountUseCase: Injector.get(),
    );
  }

  @override
  EditAccountState get initialState => EditAccountState.initial();

  @override
  Stream<EditAccountState> mapEventToState(EditAccountEvent event) async* {
    if (event is CoverChanged) {
      yield state.copyWith(coverImage: LocalUserImage(event.cover));
    } else if (event is ProfilePicChanged) {
      yield state.copyWith(profileImage: LocalUserImage(event.profilePic));
    } else if (event is MonikerChanged) {
      yield state.copyWith(moniker: event.moniker);
    } else if (event is NameChanged) {
      yield state.copyWith(name: event.name);
    } else if (event is SurnameChanged) {
      yield state.copyWith(surname: event.surname);
    } else if (event is BioChanged) {
      yield state.copyWith(bio: event.bio);
    } else if (event is SaveAccount) {
      yield* _handleSaveAccount();
    }
  }

  Stream<EditAccountState> _handleSaveAccount() async* {
    yield state.copyWith(saving: true);
    await _saveAccountUseCase.save(
      coverPicture: state.coverImage,
      profilePicture: state.profileImage,
      moniker: state.moniker,
      name: state.name,
      surname: state.surname,
      biography: state.bio,
    );
    yield state.copyWith(saving: false);
  }
}
