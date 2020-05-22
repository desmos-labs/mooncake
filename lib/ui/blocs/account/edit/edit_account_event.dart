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

  @override
  String toString() => 'MonikerChanged { moniker: $moniker }';
}

/// Tells the Bloc that the name has changed.
class NameChanged extends EditAccountEvent {
  final String name;

  NameChanged(this.name);

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'NameChanged { name: $name }';
}

/// Tells the Bloc that the surname has changed.
class SurnameChanged extends EditAccountEvent {
  final String surname;

  SurnameChanged(this.surname);

  @override
  List<Object> get props => [surname];

  @override
  String toString() => 'SurnameChanged { surname: $surname }';
}

/// Tells the Bloc that the bio of the user has changed.
class BioChanged extends EditAccountEvent {
  final String bio;

  BioChanged(this.bio);

  @override
  List<Object> get props => [bio];

  @override
  String toString() => 'BioChanged { bio: $bio }';
}

/// Tells the Bloc that the cover picture has changed.
class CoverChanged extends EditAccountEvent {
  final File cover;

  CoverChanged(this.cover);

  @override
  List<Object> get props => [cover];

  @override
  String toString() => 'CoverChanged { cover: ${cover.absolute} }';
}

/// Tells the Bloc that the profile picture has changed.
class ProfilePicChanged extends EditAccountEvent {
  final File profilePic;

  ProfilePicChanged(this.profilePic);

  @override
  List<Object> get props => [profilePic];

  @override
  String toString() => 'ProfilePicChanged { '
      'profilePic: ${profilePic.absolute} '
      '}';
}

/// Tells the Bloc that the user wants to save his account.
class SaveAccount extends EditAccountEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'SaveAccount';
}
