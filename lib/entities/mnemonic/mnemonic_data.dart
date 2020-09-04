import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'mnemonic_data.g.dart';

/// Contains the mnemonic data that can be used to recover from an existing
/// account.
@immutable
@JsonSerializable(explicitToJson: true)
class MnemonicData extends Equatable {
  /// Represents the IV used during the encryption, in Base64.
  @JsonKey(name: 'ivBase64')
  final String ivBase64;

  /// Represents the encrypted mnemonic, encoded in Base64.
  @JsonKey(name: 'encryptedMnemonicBase64')
  final String encryptedMnemonicBase64;

  const MnemonicData({
    @required this.ivBase64,
    @required this.encryptedMnemonicBase64,
  })  : assert(ivBase64 != null),
        assert(encryptedMnemonicBase64 != null);

  factory MnemonicData.fromJson(Map<String, dynamic> json) {
    return _$MnemonicDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MnemonicDataToJson(this);
  }

  @override
  List<Object> get props {
    return [ivBase64, encryptedMnemonicBase64];
  }
}
