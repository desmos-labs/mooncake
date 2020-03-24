import 'package:dependencies/dependencies.dart';
import 'package:mooncake/usecases/usecases.dart';

class UseCaseModule implements Module {
  @override
  void configure(Binder binder) {
    binder
      // Account use cases
      ..bindFactory((injector, params) => CheckLoginUseCase(
            walletRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GenerateMnemonicUseCase())
      ..bindFactory((injector, params) => GetAccountUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetAuthenticationMethod(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => LoginUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => LogoutUseCase(
            walletRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => SetAuthenticationMethodUseCase(
            userRepository: injector.get(),
          ))

      // Biometrics use cases
      ..bindFactory((injector, params) => CanUseBiometricsUseCase())

      // Notifications use cases
      ..bindFactory((injector, params) => GetNotificationsUseCase(
            repository: injector.get(),
          ))

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
      ..bindFactory((injector, params) => GetPostDetailsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetHomePostsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetHomeEventsUseCase(
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
      ..bindFactory((injector, params) => UpdatePostsStatusUseCase(
            postsRepository: injector.get(),
          ))

      // Settings use cases
      ..bindFactory((injector, params) => SaveSettingUseCase(
            settingsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetSettingUseCase(
            settingsRepository: injector.get(),
          ));
  }
}
