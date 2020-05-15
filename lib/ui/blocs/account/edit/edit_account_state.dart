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

  EditAccountState({
    @required this.moniker,
    @required this.name,
    @required this.surname,
    @required this.bio,
    @required this.coverImage,
    @required this.profileImage,
  });

  factory EditAccountState.initial() {
    return EditAccountState(
      moniker: null,
      name: null,
      surname: null,
      bio: null,
      coverImage: null,
      profileImage: null,
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
    ];
  }
}
