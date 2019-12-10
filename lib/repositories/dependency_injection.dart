import 'package:dependencies/dependencies.dart';
import 'package:dwitter/usecases/posts/posts.dart';
import 'package:dwitter/usecases/user/user.dart';
import 'package:dwitter/usecases/wallet/wallet.dart';

import 'posts/posts_repository_impl.dart';
import 'user/user_repository_impl.dart';
import 'wallet/wallet_repository_impl.dart';

/// Represents the module that is used during dependency injection
/// to provide repositories instances.
class RepositoriesModule implements Module {
  @override
  void configure(Binder binder) {
    binder
      ..bindSingleton<UserRepository>(UserRepositoryImpl())
      ..bindLazySingleton<WalletRepository>(
          (injector, params) => WalletRepositoryImpl(
                walletSource: injector.get(),
              ))
      ..bindLazySingleton<PostsRepository>(
          (injector, params) => PostsRepositoryImpl(
                localSource: injector.get(name: "local"),
                remoteSource: injector.get(name: "remote"),
              ));
  }
}
