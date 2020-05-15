import 'dart:io';

import 'package:equatable/equatable.dart';

/// Represents any event correlated to the edit account.
abstract class EditAccountEvent extends Equatable {
  const EditAccountEvent();
}

/// Tells the Bloc that the user moniker has changed.
class MonikerChanged extends EditAccountEvent {
  final String moniker;

  MonikerChanged(this.moniker);

  @override
  List<Object> get props => [moniker];
}

/// Tells the Bloc that the name has changed.
class NameChanged extends EditAccountEvent {
  final String name;

  NameChanged(this.name);

  @override
  List<Object> get props => [name];
}

/// Tells the Bloc that the surname has changed.
class SurnameChanged extends EditAccountEvent {
  final String surname;

  SurnameChanged(this.surname);

  @override
  List<Object> get props => [surname];
}

/// Tells the Bloc that the bio of the user has changed.
class BioChanged extends EditAccountEvent {
  final String bio;

  BioChanged(this.bio);

  @override
  List<Object> get props => [bio];
}

/// Tells the Bloc that the cover picture has changed.
class CoverChanged extends EditAccountEvent {
  final File cover;

  CoverChanged(this.cover);

  @override
  List<Object> get props => [cover];
}

/// Tells the Bloc that the profile picture has changed.
class ProfilePicChanged extends EditAccountEvent {
  final File profilePic;

  ProfilePicChanged(this.profilePic);

  @override
  List<Object> get props => [profilePic];
}
