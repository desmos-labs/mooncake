import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to retrieve the current user of the application.
class GetAccountUseCase {
  final UserRepository _userRepository;

  GetAccountUseCase({@required UserRepository userRepository})
      : _userRepository = userRepository;

  /// Returns the locally stored [MooncakeAccount] having the given [address].
  Future<MooncakeAccount> single(String address) {
    return _userRepository.getAccount(address);
  }
}
