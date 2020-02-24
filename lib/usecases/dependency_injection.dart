import 'package:dependencies/dependencies.dart';
import 'package:mooncake/usecases/usecases.dart';

class UseCaseModule implements Module {
  @override
  void configure(Binder binder) {
    binder
      // Login use cases
      ..bindFactory((injector, params) => CheckLoginUseCase(
            walletRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => LogoutUseCase(
            walletRepository: injector.get(),
          ))
      // Mnemonic use cases
      ..bindFactory((injector, params) => GenerateMnemonicUseCase())
      // Posts use cases
      ..bindFactory((injector, params) => GetUserReactionsToPost(
            walletRepository: injector.get(),
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => CreatePostUseCase(
            walletRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetCommentsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetPostsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => ManagePostReactionsUseCase(
            postsRepository: injector.get(),
            walletRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => SyncPostsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => SavePostUseCase(
            postsRepository: injector.get(),
          ))
      // User use cases
      ..bindFactory((injector, params) => LoginUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetAddressUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetAccountUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetUserUseCase(
            userRepository: injector.get(),
          ));
  }
}
