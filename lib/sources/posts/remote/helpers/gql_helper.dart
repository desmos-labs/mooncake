import 'package:mooncake/entities/entities.dart';

/// Allows to easily work with GraphQL-related stuff.
class GqlHelper {
  String get _postContents => """
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

  /// Returns a GraphQL [String] that allows to query for all the mooncake
  /// posts.
  String get postsGqlQuery => """
  post(
    where: { subspace: {_eq: "${Constants.SUBSPACE}"} }, 
    order_by: { created: desc },
  ) {
    $_postContents
  }
  """;

  String homePosts(int limit) => """
  post(
    where: { 
      parent_id: {_is_null: true}, 
      subspace: {_eq: "${Constants.SUBSPACE}"} 
    }
    order_by: { created: desc },
    limit: $limit,
  ) { 
    $_postContents
  }
  """;

  String get homeEvents => """
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
  post(
    where: { id: {_eq: "$id"}, subspace: {_eq: "${Constants.SUBSPACE}"} }, 
  ) {
    $_postContents
  }
  """;
}
