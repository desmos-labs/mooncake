import 'package:dependencies/dependencies.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mooncake/usecases/usecases.dart';

class UseCaseModule implements Module {
  @override
  void configure(Binder binder) {
    final authentication = LocalAuthentication();

    binder
      // Account use cases
      ..bindFactory((injector, params) => CheckLoginUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => EncryptMnemonicUseCase())
      ..bindFactory((injector, params) => GenerateMnemonicUseCase())
      ..bindFactory((injector, params) => GetAccountUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetAccountsUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetActiveAccountUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetAuthenticationMethodUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetMnemonicUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => DecryptMnemonicUseCase())
      ..bindFactory((injector, params) => LoginUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => LogoutUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => RefreshAccountUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => SaveAccountUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => SetAuthenticationMethodUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => SetAccountActiveUsecase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => SaveWalletUseCase(
            userRepository: injector.get(),
          ))

      // Biometrics use cases
      ..bindFactory((injector, params) => CanUseBiometricsUseCase(
            localAuthentication: authentication,
          ))
      ..bindFactory((injector, params) => GetAvailableBiometricsUseCase(
            localAuthentication: authentication,
          ))

      // Notifications use cases
      ..bindFactory((injector, params) => GetNotificationsUseCase(
            repository: injector.get(),
          ))

      // Posts use cases
      ..bindFactory((injector, params) => CreatePostUseCase(
            userRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => DeletePostsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetCommentsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetPostDetailsUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => HidePostUseCase(
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
            userRepository: injector.get(),
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
      ..bindFactory((injector, params) => VotePollUseCase(
            userRepository: injector.get(),
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => ReportPostUseCase())
      ..bindFactory((injector, params) => UpdatePostUseCase(
            postsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => DeletePostUseCase(
            postsRepository: injector.get(),
          ))

      // Settings use cases
      ..bindFactory((injector, params) => SaveSettingUseCase(
            settingsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => GetSettingUseCase(
            settingsRepository: injector.get(),
          ))
      ..bindFactory((injector, params) => WatchSettingUseCase(
            settingsRepository: injector.get(),
          ))
      // Users use cases
      ..bindFactory((injector, params) => BlockUserUseCase(
            usersRepository: injector.get(),
          ));
  }
}
