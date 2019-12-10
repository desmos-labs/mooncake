import 'package:dwitter/entities/entities.dart';
import 'package:dwitter/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to know if a post having a specific id has been liked from
/// the user or not.
class IsPostLikedUseCase {
  final WalletRepository _walletRepository;
  final PostsRepository _postsRepository;

  IsPostLikedUseCase(
      {@required WalletRepository walletRepository,
      @required PostsRepository postsRepository})
      : assert(walletRepository != null),
        _walletRepository = walletRepository,
        assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Checks if the post having the given [postId] has been liked from
  /// the current application user or not.
  Future<bool> verify(Post post) async {
    final wallet = await _walletRepository.getWallet();
    return post != null && post.containsLikeFromUser(wallet.bech32Address);
  }
}
