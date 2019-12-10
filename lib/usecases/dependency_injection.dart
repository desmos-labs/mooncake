import 'package:dependencies/dependencies.dart';
import 'package:dwitter/usecases/usecases.dart';

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
      ..bindFactory((injector, params) => IsPostLikedUseCase(
            walletRepository: injector.get(),
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => CreatePostUseCase(
            walletRepository: injector.get(),
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetCommentsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetPostsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => LikePostUseCase(
            postsRepository: injector.get(),
            walletRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => SyncPostsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => UnlikePostUseCase(
            postsRepository: injector.get(),
            walletRepository: injector.get(),
          ))
      // Wallet use cases
      ..bindFactory((injector, params) => SaveWalletUseCase(
            walletRepository: injector.get(),
          ));
  }
}
