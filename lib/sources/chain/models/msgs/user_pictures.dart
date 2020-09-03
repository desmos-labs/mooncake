import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_pictures.g.dart';

/// Represents the object that contains the user pictures.
@immutable
@JsonSerializable(explicitToJson: true)
class UserPictures extends Equatable {
  @JsonKey(name: 'cover')
  final String cover;

  @JsonKey(name: 'profile')
  final String profile;

  UserPictures({
    this.cover,
    this.profile,
  })  : assert(cover == null || cover.trim().isNotEmpty),
        assert(profile == null || profile.trim().isNotEmpty);

  factory UserPictures.fromJson(Map<String, dynamic> json) {
    return _$UserPicturesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserPicturesToJson(this);
  }

  @override
  List<Object> get props {
    return [
      cover,
      profile,
    ];
  }
}
