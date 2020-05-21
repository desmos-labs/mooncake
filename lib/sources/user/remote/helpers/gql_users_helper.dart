import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:mooncake/entities/entities.dart';

class GqlUsersHelper {
  static const String userContents = """
  address
  moniker
  cover_pic
  profile_pic
  bio
  """;

  /// Converts the given [gqlData] retrieved from the remote GraphQL
  /// server into a list of users.
  /// If no data is present, returns an empty list instead.
  static List<User> _convertPostsGqlResponse(dynamic posts) {
    return (posts as List<dynamic>)
        .map((json) => User.fromJson(json))
        .toList();
  }

  /// Gets the user having the given [address] by using the given [client].
  /// if no user could be found, returns a local [User] instead.
  static Future<User> getUserByAddress(
    GraphQLClient client,
    String address,
  ) async {
    final query = """
    query UserByAddress {
      users:user(where:{address: {_eq:$address}}) {
        address
        moniker
        name
        surname
        cover_pic
        profile_pic
        bio
      }
    }
    """;

    final data = await client.query(
      QueryOptions(
        documentNode: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    final posts = await compute(_convertPostsGqlResponse, data.data["users"]);
    return posts.isEmpty ? User.fromAddress(address) : posts[0];
  }
}
