import 'dart:io';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to save the given object as the current user account.
class SaveAccountUseCase {
  final UserRepository _userRepository;

  SaveAccountUseCase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  /// Saves the given [account] as the current user account.
  Future<void> save(MooncakeAccount account) {
    return _userRepository.saveAccount(account);
  }
}
