import 'package:dwitter/entities/entities.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String TABLE_POSTS = "posts";

  static const String KEY_ID = "id";
  static const String KEY_PARENT_ID = "parent_id";
  static const String KEY_MESSAGE = "message";
  static const String KEY_CREATED = "created";
  static const String KEY_LAST_EDITED = "last_edited";
  static const String KEY_ALLOWS_COMMENTS = "allows_comments";
  static const String KEY_EXTERNAL_REFERENCE = "external_reference";
  static const String KEY_OWNER = "owner";
  static const String KEY_OWNER_IS_USER = "owner_is_user";
  static const String KEY_LIKED = "liked";
  static const String KEY_STATUS = "status";

  static const String TABLE_LIKES = "likes";
  static const String KEY_LIKED_POST_ID = "post_id";
  static const String KEY_LIKE_OWNER = "like_owner";

  Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'posts_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          """
          CREATE TABLE $TABLE_POSTS (
          $KEY_ID TEXT NOT NULL,
          $KEY_PARENT_ID TEXT,
          $KEY_MESSAGE TEXT,
          $KEY_CREATED TEXT,
          $KEY_LAST_EDITED TEXT,
          $KEY_ALLOWS_COMMENTS INTEGER,
          $KEY_EXTERNAL_REFERENCE TEXT PRIMARY KEY,
          $KEY_OWNER TEXT,
          $KEY_OWNER_IS_USER INTEGER,
          $KEY_LIKED INTEGER,
          $KEY_STATUS TEXT
          );
          """,
        );

        await db.execute("""
        CREATE TABLE $TABLE_LIKES (
        $KEY_LIKED_POST_ID TEXT NOT NULL,
        $KEY_LIKE_OWNER TEXT NOT NULL,
        PRIMARY KEY($KEY_LIKED_POST_ID, $KEY_LIKE_OWNER)
        );
        """);
      },
      version: 1,
    );
  }

  Map<String, dynamic> postToMap(Post post) {
    return {
      KEY_ID: post.id,
      KEY_PARENT_ID: post.parentId,
      KEY_MESSAGE: post.message,
      KEY_CREATED: post.created,
      KEY_LAST_EDITED: post.lastEdited,
      KEY_ALLOWS_COMMENTS: post.allowsComments ? 1 : 0,
      KEY_EXTERNAL_REFERENCE: post.externalReference,
      KEY_OWNER: post.owner,
      KEY_OWNER_IS_USER: post.ownerIsUser ? 1 : 0,
      KEY_LIKED: post.liked ? 1 : 0,
      KEY_STATUS: post.status.toString(),
    };
  }

  Post postFromMap(
    Map<String, dynamic> map,
    List<Like> likes,
    List<String> commentIds,
  ) {
    return Post(
      id: map[KEY_ID] as String,
      parentId: map[KEY_PARENT_ID] as String,
      message: map[KEY_MESSAGE] as String,
      created: map[KEY_CREATED] as String,
      lastEdited: map[KEY_LAST_EDITED] as String,
      allowsComments: map[KEY_ALLOWS_COMMENTS] == 1,
      externalReference: map[KEY_EXTERNAL_REFERENCE] as String,
      owner: map[KEY_OWNER] as String,
      ownerIsUser: map[KEY_OWNER_IS_USER] == 1,
      liked: map[KEY_LIKED] == 1,
      status:
          PostStatus.values.firstWhere((i) => i.toString() == map[KEY_STATUS]),
      commentsIds: commentIds,
      likes: likes,
    );
  }

  Map<String, dynamic> likeToMap(String postId, Like like) {
    return {
      KEY_LIKED_POST_ID: postId,
      KEY_LIKE_OWNER: like.owner,
    };
  }

  Like likeFromMap(Map<String, dynamic> map) {
    return Like(
      owner: map[KEY_LIKE_OWNER] as String,
    );
  }
}
