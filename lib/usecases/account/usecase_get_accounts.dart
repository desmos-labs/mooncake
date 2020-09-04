import 'package:meta/meta.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/entities.dart';

class GetAccountsUseCase {
  final UserRepository _userRepository;

  GetAccountsUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  /// Returns all locally stored accounts that can be used.
  Future<List<MooncakeAccount>> all() {
    return _userRepository.getAccounts();
  }
}
