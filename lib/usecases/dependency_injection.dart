import 'package:dependencies/dependencies.dart';
import 'package:desmosdemo/usecases/usecases.dart';

class UseCaseModule implements Module {
  @override
  void configure(Binder binder) {
    binder
      // Posts use cases
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
          ));
  }
}
