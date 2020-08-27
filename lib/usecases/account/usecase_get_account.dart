import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to retrieve the current user of the application.
class GetAccountUseCase {
  final UserRepository _userRepository;

  GetAccountUseCase({@required UserRepository userRepository})
      : this._userRepository = userRepository;

  /// Returns the current user of the application.
  Future<MooncakeAccount> single(String address) {
    return _userRepository.getAccount(address);
  }

  /// Returns the current user of the application.
  Future<MooncakeAccount> getActiveAccount() {
    return _userRepository.getActiveAccount();
  }

  /// Returns the [Stream] that emits all the [MooncakeAccount] objects
  /// as soon as they are stored.
  Stream<MooncakeAccount> stream() {
    return _userRepository.accountStream;
  }
}
