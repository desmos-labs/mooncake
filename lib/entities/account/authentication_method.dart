import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'authentication_method.g.dart';

/// Represents a user authentication method.
@immutable
@JsonSerializable(explicitToJson: true, createFactory: false)
abstract class AuthenticationMethod extends Equatable {
  static const String KEY_TYPE = "type";

  /// Identifies the type of authentication.
  @JsonKey(name: KEY_TYPE)
  final String type;

  static const TYPE_BIOMETRICS = "biometrics";
  static const TYPE_PASSWORD = "password";

  AuthenticationMethod({@required this.type}) : assert(type != null);

  factory AuthenticationMethod.fromJson(Map<String, dynamic> json) {
    final type = json[KEY_TYPE];
    switch (type) {
      case TYPE_BIOMETRICS:
        return BiometricAuthentication.fromJson(json);
      case TYPE_PASSWORD:
        return PasswordAuthentication.fromJson(json);
      default:
        throw Exception("Authentication type not supported: $type");
    }
  }

  /// Converts this object to a JSON [Map].
  Map<String, dynamic> toJson() {
    Map<String, dynamic> base = _$AuthenticationMethodToJson(this);
    base.addAll(asJson());
    return base;
  }

  /// Converts this object to a JSON object.
  Map<String, dynamic> asJson();

  @override
  List<Object> get props => [type];
}

/// Represents the authentication method that relies on the current
/// device biometric authentication.
@JsonSerializable()
class BiometricAuthentication extends AuthenticationMethod {
  BiometricAuthentication() : super(type: AuthenticationMethod.TYPE_BIOMETRICS);

  factory BiometricAuthentication.fromJson(Map<String, dynamic> json) =>
      _$BiometricAuthenticationFromJson(json);

  @override
  List<Object> get props => super.props + [];

  @override
  Map<String, dynamic> asJson() => _$BiometricAuthenticationToJson(this);
}

/// Represents the authentication method that consists of a password.
@immutable
@JsonSerializable(explicitToJson: true)
class PasswordAuthentication extends AuthenticationMethod {
  @JsonKey(name: "password")
  final String hashedPassword;

  PasswordAuthentication({
    @required this.hashedPassword,
  })  : assert(hashedPassword != null),
        super(type: AuthenticationMethod.TYPE_PASSWORD);

  factory PasswordAuthentication.fromJson(Map<String, dynamic> json) =>
      _$PasswordAuthenticationFromJson(json);

  @override
  Map<String, dynamic> asJson() => _$PasswordAuthenticationToJson(this);

  @override
  List<Object> get props => super.props + [hashedPassword];
}
