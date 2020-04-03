// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$AuthenticationMethodToJson(
        AuthenticationMethod instance) =>
    <String, dynamic>{
      'type': instance.type,
    };

BiometricAuthentication _$BiometricAuthenticationFromJson(
    Map<String, dynamic> json) {
  return BiometricAuthentication();
}

Map<String, dynamic> _$BiometricAuthenticationToJson(
        BiometricAuthentication instance) =>
    <String, dynamic>{};

PasswordAuthentication _$PasswordAuthenticationFromJson(
    Map<String, dynamic> json) {
  return PasswordAuthentication(
    hashedPassword: json['password'] as String,
  );
}

Map<String, dynamic> _$PasswordAuthenticationToJson(
        PasswordAuthentication instance) =>
    <String, dynamic>{
      'password': instance.hashedPassword,
    };
