import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

class SetMnemonicBackupPopupUseCase {
  final UserRepository _userRepository;

  SetMnemonicBackupPopupUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  Stream<bool> stream() {
    return _userRepository.shouldDisplayMnemonicBackupPopup();
  }
}
