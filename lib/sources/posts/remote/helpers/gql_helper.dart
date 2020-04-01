import 'package:flutter/foundation.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';

class HomePostsData {
  final String endpoint;
  final String subspace;
  final int limit;

  HomePostsData(this.endpoint, this.subspace, this.limit);
}

class PostDetailsData {
  final String endpoint;
  final String subspace;
  final String id;

  PostDetailsData({
    @required this.endpoint,
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
  media {
    uri
    mime_type
  }
  message
  optional_data
  parent_id
  reactions {
    user {
      address
    }
    value
  }
  user {
    address
  }
  """;

  /// Converts the given [gqlData] retrieved from the remote GraphQL
  /// server into a list of posts.
  /// If no data is present, returns an empty list instead.
  static List<Post> _convertGqlResponse(dynamic gqlData) {
    final data = gqlData as Map<String, dynamic>;
    if (data.containsKey("post")) {
      return (data["post"] as List<dynamic>)
          .map((e) => Post.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<List<Post>> getHomePosts(
    GraphQLClient client,
    HomePostsData queryData,
  ) async {
    final query = """
    query HomePosts {
      post(
        where: { 
          parent_id: {_is_null: true}, 
          subspace: {_eq: "${queryData.subspace}"} 
        }
        order_by: { created: desc },
        limit: ${queryData.limit},
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
    return compute(_convertGqlResponse, data.data);
  }

  static Future<Post> getPostDetails(
    GraphQLClient client,
    PostDetailsData queryData,
  ) async {
    final query = """
    query PostById {
      post(
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
    final posts = await compute(_convertGqlResponse, data.data);
    return posts.isEmpty ? null : posts[0];
  }

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

  String postDetailsQuery(String id) => """
  
  """;
}
