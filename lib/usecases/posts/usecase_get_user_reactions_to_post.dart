import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to get the reactions from the current app user to a post
/// having a specific id.
class GetUserReactionsToPost {
  final UserRepository _walletRepository;

  GetUserReactionsToPost(
      {@required UserRepository walletRepository,
      @required PostsRepository postsRepository})
      : assert(walletRepository != null),
        _walletRepository = walletRepository;

  /// Reads the Bech32 address of the current app user, and gets all the
  /// reactions from that address which are associated to the given [post].
  Future<List<Reaction>> verify(Post post) async {
    final address = await _walletRepository.getAddress();
    return post.reactions.where((r) => r.owner == address).toList();
  }
}
