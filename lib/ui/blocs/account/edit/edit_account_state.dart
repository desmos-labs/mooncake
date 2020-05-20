import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the current state of the edit account screen.
class EditAccountState extends Equatable {
  final String moniker;
  final String name;
  final String surname;
  final String bio;
  final AccountImage coverImage;
  final AccountImage profileImage;

  final bool saving;

  EditAccountState({
    @required this.moniker,
    @required this.name,
    @required this.surname,
    @required this.bio,
    @required this.coverImage,
    @required this.profileImage,
    @required this.saving,
  });

  factory EditAccountState.initial() {
    return EditAccountState(
      moniker: null,
      name: null,
      surname: null,
      bio: null,
      coverImage: null,
      profileImage: null,
      saving: false,
    );
  }

  EditAccountState copyWith({
    String moniker,
    String name,
    String surname,
    String bio,
    AccountImage coverImage,
    AccountImage profileImage,
    bool saving,
  }) {
    return EditAccountState(
      moniker: moniker ?? this.moniker,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      bio: bio ?? this.bio,
      coverImage: coverImage ?? this.coverImage,
      profileImage: profileImage ?? this.profileImage,
      saving: saving ?? this.saving,
    );
  }

  @override
  List<Object> get props {
    return [
      moniker,
      name,
      surname,
      bio,
      coverImage,
      profileImage,
      saving,
    ];
  }
}
