import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:password_strength/password_strength.dart';
import './bloc.dart';

/// Represents the Bloc that is used inside the screen allowing the user
/// to set a custom password to protect his account.
class SetPasswordBloc extends Bloc<SetPasswordEvent, SetPasswordState> {
  SetPasswordBloc();

  factory SetPasswordBloc.create() {
    return SetPasswordBloc();
  }

  @override
  SetPasswordState get initialState => SetPasswordState.initial();

  @override
  Stream<SetPasswordState> mapEventToState(SetPasswordEvent event) async* {
    if (event is PasswordChanged) {
      yield* _mapPasswordChangedEventToState(event);
    } else if (event is TriggerPasswordVisibility) {
      yield* _mapTriggerPasswordVisibilityEventToState();
    }
  }

  Stream<SetPasswordState> _mapPasswordChangedEventToState(
    PasswordChanged event,
  ) async* {
    final strength = estimatePasswordStrength(event.newPassword);
    PasswordSecurity security = PasswordSecurity.UNKNOWN;
    if (strength < 0.50) {
      security = PasswordSecurity.LOW;
    } else if (strength < 0.75) {
      security = PasswordSecurity.MEDIUM;
    } else {
      security = PasswordSecurity.HIGH;
    }

    yield state.copyWith(
      inputPassword: event.newPassword,
      passwordSecurity: security,
    );
  }

  Stream<SetPasswordState> _mapTriggerPasswordVisibilityEventToState() async* {
    yield state.copyWith(showPassword: !state.showPassword);
  }
}
