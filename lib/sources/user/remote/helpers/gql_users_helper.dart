import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:mooncake/entities/entities.dart';

class GqlUsersHelper {
  static const String userContents = '''
  address
  dtag
  moniker
  cover_pic
  profile_pic
  bio
  ''';

  /// Converts the given [gqlData] retrieved from the remote GraphQL
  /// server into a list of users.
  /// If no data is present, returns an empty list instead.
  static List<User> _convertUsersGqlResponse(dynamic posts) {
    return (posts as List<dynamic>)
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Gets the user having the given [address] by using the given [client].
  /// if no user could be found, returns a local [User] instead.
  static Future<User> getUserByAddress(
    GraphQLClient client,
    String address,
  ) async {
    final query = '''
    query UserByAddress {
      users: profile (where:{address: {_eq:"$address"}}) {
        ${GqlUsersHelper.userContents}
      }
    }
    ''';

    final data = await client.query(
      QueryOptions(
        documentNode: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    final users = await compute(_convertUsersGqlResponse, data.data['users']);
    return users.isEmpty ? User.fromAddress(address) : users[0];
  }
}
