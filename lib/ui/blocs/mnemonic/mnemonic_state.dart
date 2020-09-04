import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:password_strength/password_strength.dart';

/// Represents a generic state for the screen that allows the user to view
/// his own mnemonic.
@immutable
class MnemonicState extends Equatable {
  /// Tells whether the user has checked the box required to
  /// make sure he has read the warning.
  final bool hasCheckedBox;

  final bool showMnemonic;
  final List<String> mnemonic;

  MnemonicState({
    @required this.hasCheckedBox,
    @required this.showMnemonic,
    @required this.mnemonic,
  })  : assert(hasCheckedBox != null),
        assert(showMnemonic != null),
        assert(mnemonic != null);

  factory MnemonicState.initial() {
    return MnemonicState(
      hasCheckedBox: false,
      showMnemonic: false,
      mnemonic: [],
    );
  }

  MnemonicState copyWith({
    bool hasCheckedBox,
    bool showMnemonic,
    List<String> mnemonic,
  }) {
    return MnemonicState(
      hasCheckedBox: hasCheckedBox ?? this.hasCheckedBox,
      showMnemonic: showMnemonic ?? this.showMnemonic,
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  @override
  String toString() => 'MnemonicState { '
      'hasCheckedBox: $hasCheckedBox, '
      'showMnemonic: $showMnemonic '
      ' }';

  @override
  List<Object> get props {
    return [
      hasCheckedBox,
      showMnemonic,
      mnemonic,
    ];
  }
}

/// Represents the mnemonic screen state during which the user has decided
/// to export his mnemonic and should specify the password with which to
/// encrypt it.
@immutable
class ExportingMnemonic extends MnemonicState {
  final String encryptPassword;
  final bool exportingMnemonic;

  /// Indicates the security of the password.
  PasswordSecurity get passwordSecurity {
    if (encryptPassword == null) {
      return PasswordSecurity.UNKNOWN;
    }

    final strength = estimatePasswordStrength(encryptPassword);
    var security = PasswordSecurity.UNKNOWN;
    if (strength < 0.50) {
      security = PasswordSecurity.LOW;
    } else if (strength < 0.75) {
      security = PasswordSecurity.MEDIUM;
    } else {
      security = PasswordSecurity.HIGH;
    }
    return security;
  }

  /// Tells whenever the export can be enabled or not.
  bool get enableExport {
    return passwordSecurity == PasswordSecurity.MEDIUM ||
        passwordSecurity == PasswordSecurity.HIGH;
  }

  ExportingMnemonic({
    @required this.encryptPassword,
    @required this.exportingMnemonic,
    @required bool hasCheckedBox,
    @required bool showMnemonic,
    @required List<String> mnemonic,
  })  : assert(exportingMnemonic != null),
        super(
          hasCheckedBox: hasCheckedBox,
          mnemonic: mnemonic,
          showMnemonic: showMnemonic,
        );

  factory ExportingMnemonic.fromMnemonicState(MnemonicState state) {
    return ExportingMnemonic(
      encryptPassword: null,
      exportingMnemonic: false,
      hasCheckedBox: state.hasCheckedBox,
      showMnemonic: state.showMnemonic,
      mnemonic: state.mnemonic,
    );
  }

  @override
  ExportingMnemonic copyWith({
    bool hasCheckedBox,
    bool showMnemonic,
    List<String> mnemonic,
    String encryptPassword,
    bool exportingMnemonic,
  }) {
    return ExportingMnemonic(
      hasCheckedBox: hasCheckedBox ?? this.hasCheckedBox,
      showMnemonic: showMnemonic ?? this.showMnemonic,
      mnemonic: mnemonic ?? this.mnemonic,
      encryptPassword: encryptPassword ?? this.encryptPassword,
      exportingMnemonic: exportingMnemonic ?? this.exportingMnemonic,
    );
  }

  @override
  String toString() => 'ExportingMnemonic { '
      'encryptPassword: $encryptPassword, '
      'exportingMnemonic: $exportingMnemonic '
      ' }';

  @override
  List<Object> get props {
    return super.props +
        [
          encryptPassword,
          exportingMnemonic,
        ];
  }
}
