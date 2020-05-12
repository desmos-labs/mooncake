import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class MnemonicState extends Equatable {
  final bool showMnemonic;
  final List<String> mnemonic;

  MnemonicState({
    @required this.showMnemonic,
    @required this.mnemonic,
  })  : assert(showMnemonic != null),
        assert(mnemonic != null);

  factory MnemonicState.initial() {
    return MnemonicState(
      showMnemonic: false,
      mnemonic: [],
    );
  }

  MnemonicState copyWith({
    bool showMnemonic,
    List<String> mnemonic,
  }) {
    return MnemonicState(
      showMnemonic: showMnemonic ?? this.showMnemonic,
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  @override
  String toString() => 'MnemonicState { showMnemonic: $showMnemonic }';

  @override
  List<Object> get props => [showMnemonic, mnemonic];
}
