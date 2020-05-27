import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_image.g.dart';

enum AccountImageType {
  @JsonValue("local")
  LOCAL,

  @JsonValue("network")
  NETWORK,

  @JsonValue("no_image")
  NO_IMAGE
}

/// Represents the account image. It can be either:
/// - a local image if it's not synced to the chain yet
/// - a network image if it has been uploaded online
/// - an object identifying the user has no image.
@JsonSerializable(explicitToJson: true, createFactory: false)
abstract class AccountImage extends Equatable {
  @JsonKey(name: "type")
  final AccountImageType type;

  const AccountImage(this.type);

  @deprecated
  Map<String, dynamic> asJson();

  static AccountImage fromJson(Map<String, dynamic> json) {
    final type = _$AccountImageTypeEnumMap.entries.firstWhere(
      (element) => element == json['type'],
      orElse: () => null,
    );
    switch (type?.key) {
      case AccountImageType.LOCAL:
        return LocalUserImage.fromJson(json);
      case AccountImageType.NETWORK:
        return NetworkUserImage.fromJson(json);
      default:
        return NoUserImage.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    final json = asJson();
    json.addAll(_$AccountImageToJson(this));
    return json;
  }
}

/// Represents a locally stored user image.
@immutable
class LocalUserImage extends AccountImage {
  final File image;

  const LocalUserImage(this.image) : super(AccountImageType.LOCAL);

  factory LocalUserImage.fromJson(Map<String, dynamic> json) {
    return LocalUserImage(File(json['image'] as String));
  }

  @override
  List<Object> get props => [image];

  @override
  Map<String, dynamic> asJson() {
    return {
      'image': image.absolute.path,
    };
  }
}

/// Represents a network stored image.
@immutable
@JsonSerializable(explicitToJson: true)
class NetworkUserImage extends AccountImage {
  @JsonKey(name: "url")
  final String url;

  const NetworkUserImage(this.url) : super(AccountImageType.NETWORK);

  factory NetworkUserImage.fromJson(Map<String, dynamic> json) {
    return _$NetworkUserImageFromJson(json);
  }

  @override
  Map<String, dynamic> asJson() {
    return _$NetworkUserImageToJson(this);
  }

  @override
  List<Object> get props => [url];
}

/// Represents a non existing image.
@immutable
@JsonSerializable(explicitToJson: true)
class NoUserImage extends AccountImage {
  const NoUserImage() : super(AccountImageType.NO_IMAGE);

  factory NoUserImage.fromJson(Map<String, dynamic> json) {
    return _$NoUserImageFromJson(json);
  }

  @override
  List<Object> get props => [];

  @override
  Map<String, dynamic> asJson() {
    return _$NoUserImageToJson(this);
  }
}
