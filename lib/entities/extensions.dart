import 'package:dwitter/entities/entities.dart';

/// Defines useful extensions methods for list of posts
extension PostsExt on List<Post> {
  /// Returns the post having the given [id], [message] or [status]
  /// inside this list, or `null` if no post with such id was found.
  Post firstBy({
    String id,
    String message,
    PostStatus status,
  }) {
    return this.firstWhere((post) {
      bool condition = true;

      if (id != null && id.isNotEmpty) {
        condition &= post.id == id;
      }

      if (message != null && message.isNotEmpty) {
        condition &= post.message == message;
      }

      if (status != null) {
        condition &= post.status == status;
      }

      return condition;
    }, orElse: () => null);
  }
}

/// Defines useful extensions methods for the [Int] type.
extension IntExt on int {
  /// Converts this value into a [String] if it's greater than zero,
  /// otherwise returns an empty string.
  String toStringOrEmpty() {
    return this > 0 ? '$this' : null;
  }
}
