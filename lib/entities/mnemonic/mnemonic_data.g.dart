// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mnemonic_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MnemonicData _$MnemonicDataFromJson(Map<String, dynamic> json) {
  return MnemonicData(
    ivBase64: json['ivBase64'] as String,
    encryptedMnemonicBase64: json['encryptedMnemonicBase64'] as String,
  );
}

Map<String, dynamic> _$MnemonicDataToJson(MnemonicData instance) =>
    <String, dynamic>{
      'ivBase64': instance.ivBase64,
      'encryptedMnemonicBase64': instance.encryptedMnemonicBase64,
    };
