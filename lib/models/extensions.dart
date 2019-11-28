import 'package:desmosdemo/models/models.dart';

/// Defines useful extensions methods for list of posts
extension PostsExt on List<Post> {
  /// Returns the post having the given [postId] inside this list,
  /// or `null` if no post with such id was found.
  Post findById(String postId) {
    return this.firstWhere((p) => p.id == postId, orElse: null);
  }
}

/// Defines useful extensions methods for the [Int] type.
extension IntExt on int {
  /// Converts this value into a [String] if it's greater than zero,
  /// otherwise returns an empty string.
  String toStringOrEmpty() {
    return '${this > 0 ? this : ''}';
  }
}
