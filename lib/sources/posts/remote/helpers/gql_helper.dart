import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

class HomePostsData {
  final String subspace;

  final int start;
  final int limit;

  HomePostsData({
    @required this.subspace,
    @required this.start,
    @required this.limit,
  });
}

class PostDetailsData {
  final String subspace;
  final String id;

  PostDetailsData({
    @required this.subspace,
    @required this.id,
  });
}

/// Allows to easily work with GraphQL-related stuff.
class GqlHelper {
  static const String _postContents = """
  id
  subspace
  created
  last_edited
  allows_comments
  media: medias {
    uri
    mime_type
  }
  message
  optional_data
  parent_id
  reactions {
    user: owner {
      address
    }
    value
  }
  user: creator {
    address
  }
  comments: comments {
    id
  }
  """;

  /// Represents the GQL query that should be used when wanting to subscribe
  /// to home events such as new post being added.
  static const String homeEvents = """
  post_aggregate(
    where: {
      parent_id: {_is_null: true},
      subspace: {_eq: "${Constants.SUBSPACE}"},
    }
  ) {
    aggregate {
      count(columns: id)
    }
  }
  """;

  static Map<String, dynamic> _convertFields(Map<String, dynamic> post) {
    // Convert the comments
    post["children"] = (post["comments"] as List).map((e) => e["id"]).toList();
    return post;
  }

  /// Converts the given [gqlData] retrieved from the remote GraphQL
  /// server into a list of posts.
  /// If no data is present, returns an empty list instead.
  static List<Post> _convertPostsGqlResponse(dynamic posts) {
    return (posts as List<dynamic>)
        .map((json) => Post.fromJson(_convertFields(json)))
        .toList();
  }

  /// Returns the list of posts that should be displayed in the home
  /// page of the application, i.e. the ones not having any parent.
  static Future<List<Post>> getHomePosts(
    GraphQLClient client,
    HomePostsData queryData,
  ) async {
    final query = """
    query HomePosts {
      posts: post(
        where: { 
          parent_id: {_is_null: true}, 
          subspace: {_eq: "${queryData.subspace}"} 
        }
        order_by: { created: desc },
        offset: ${queryData.start},
        limit: ${queryData.start + queryData.limit},
      ) { 
        $_postContents
      }
    }
    """;
    final data = await client.query(
      QueryOptions(
        documentNode: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    return compute(_convertPostsGqlResponse, data.data["posts"]);
  }

  /// Returns the details of the post having the specified id and present
  /// inside the specified subspace.
  static Future<Post> getPostDetails(
    GraphQLClient client,
    PostDetailsData queryData,
  ) async {
    final query = """
    query PostById {
      post: post(
        where: { 
          id: {_eq: "${queryData.id}"}, 
          subspace: {_eq: "${queryData.subspace}"}
        }, 
      ) {
        $_postContents
      }
    }
    """;
    final data = await client.query(
      QueryOptions(
        documentNode: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    final posts = await compute(_convertPostsGqlResponse, data.data["post"]);
    return posts.isEmpty ? null : posts[0];
  }

  /// Returns the list of posts that are a comment to the post having the
  /// specified id.
  static Future<List<Post>> getPostComments(
    GraphQLClient client,
    PostDetailsData queryData,
  ) async {
    final query = """
    query PostComments {
      comments: post(
        where: { 
          parent_id: {_eq: "${queryData.id}"}, 
          subspace: {_eq: "${queryData.subspace}"} 
        },
        order_by: { created: desc },
      ) { 
        $_postContents
      }
    }
    """;
    final data = await client.query(
      QueryOptions(
        documentNode: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    return compute(_convertPostsGqlResponse, data.data["comments"]);
  }
}
