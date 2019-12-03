import 'package:bip39/bip39.dart' as bip39;
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the state of the text input that allows a user to type a mnemonic
/// phrase to properly recover an account.
class MnemonicInputState extends Equatable {
  final String mnemonic;

  MnemonicInputState({@required this.mnemonic});

  bool get isEmpty => this == MnemonicInputState.empty();
  bool get isValid =>
      mnemonic != null && bip39.validateMnemonic(mnemonic.toLowerCase());

  factory MnemonicInputState.empty() => MnemonicInputState(
        mnemonic: null,
      );

  MnemonicInputState update({
    String mnemonic,
  }) {
    return copyWith(
      mnemonic: mnemonic,
    );
  }

  MnemonicInputState copyWith({
    String mnemonic,
  }) {
    return MnemonicInputState(
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  @override
  List<Object> get props => [mnemonic];

  @override
  String toString() {
    return 'LoginInputState {'
        'mnemonic: $mnemonic '
        '}';
  }
}
