import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';

class GetMnemonicUseCase {
  final UserRepository _userRepository;

  GetMnemonicUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  Future<List<String>> get() {
    return _userRepository.getMnemonic();
  }
}
