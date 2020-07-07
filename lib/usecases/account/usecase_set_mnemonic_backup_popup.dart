import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily check if a mnemonic phrase backup popup should be shown.
class SetMnemonicBackupPopupUseCase {
  final UserRepository _userRepository;

  SetMnemonicBackupPopupUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  /// Returns `true` if a popup should be displayed and `false` otherwise.
  Future<bool> check() {
    return _userRepository.shouldDisplayMnemonicBackupPopup();
  }
}
