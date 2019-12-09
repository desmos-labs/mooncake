import 'package:bip39/bip39.dart' as bip39;
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the state of the text input that allows a user to type a mnemonic
/// phrase to properly recover an account.
class MnemonicInputState extends Equatable {
  final String verificationMnemonic;
  final String mnemonic;

  MnemonicInputState({
    @required this.mnemonic,
    @required this.verificationMnemonic,
  });

  /// Tells if the state can be considered empty
  bool get isEmpty => mnemonic == null || mnemonic.isEmpty;

  /// Tells if the state is valid
  bool get isValid =>
      mnemonic != null &&
      (verificationMnemonic == null || mnemonic == verificationMnemonic) &&
      bip39.validateMnemonic(mnemonic.toLowerCase());

  /// Creates a new empty state.
  factory MnemonicInputState.empty() => MnemonicInputState(
        verificationMnemonic: null,
        mnemonic: null,
      );

  /// Updates this state with the given data changed.
  MnemonicInputState update({
    String mnemonic,
    String verificationMnemonic,
  }) {
    return MnemonicInputState(
      mnemonic: mnemonic ?? this.mnemonic,
      verificationMnemonic: verificationMnemonic ?? this.verificationMnemonic,
    );
  }

  @override
  List<Object> get props => [mnemonic, verificationMnemonic];

  @override
  String toString() {
    return 'LoginInputState {'
        'mnemonic: $mnemonic '
        'verificationMnemonic: $verificationMnemonic '
        '}';
  }
}
