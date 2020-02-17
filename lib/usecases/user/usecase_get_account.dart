import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily retrieve the [AccountData] object containing the
/// information of the current app user.
class GetAccountUseCase {
  final UserRepository _userRepository;

  GetAccountUseCase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  /// Returns the [AccountData] object containing the info of the
  /// current user account.
  Future<AccountData> single() {
    return _userRepository.getAccount();
  }

  /// Returns a stream of [AccountData] that emits any new [AccountData]
  /// instances that are stored.
  Stream<AccountData> stream() {
    return _userRepository.observeAccount();
  }
}
