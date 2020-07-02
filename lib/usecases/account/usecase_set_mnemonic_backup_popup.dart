import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

class SetMnemonicBackupPopupUseCase {
  final UserRepository _userRepository;

  SetMnemonicBackupPopupUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  Future<dynamic> setMnemonicBackupPopup() {
    return _userRepository.shouldDisplayMnemonicBackupPopup();
  }
}
