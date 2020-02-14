import 'package:bip39/bip39.dart' as bip39;
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the state of the text input that allows a user to type a mnemonic
/// phrase to properly recover an account.
class MnemonicInputState extends Equatable {
  final String _verificationMnemonic;
  final String _mnemonic;

  MnemonicInputState({
    @required String mnemonic,
    @required String verificationMnemonic,
  })  : _mnemonic = mnemonic,
        _verificationMnemonic = verificationMnemonic;

  String get mnemonic => _mnemonic?.toLowerCase();

  String get verificationMnemonic => _verificationMnemonic?.toLowerCase();

  /// Tells if the state can be considered empty
  bool get isEmpty => _mnemonic == null || _mnemonic.isEmpty;

  /// Tells if the state is valid
  bool get isValid =>
      mnemonic != null &&
      (verificationMnemonic == null || mnemonic == verificationMnemonic) &&
      bip39.validateMnemonic(mnemonic);

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
      mnemonic: mnemonic ?? this._mnemonic,
      verificationMnemonic: verificationMnemonic ?? this._verificationMnemonic,
    );
  }

  @override
  List<Object> get props => [_mnemonic, _verificationMnemonic];
}
