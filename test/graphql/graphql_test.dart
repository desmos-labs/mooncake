import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';

void main() async {
  final link = WebSocketLink(url: "ws://localhost:8080/v1/graphql");
  final client = GraphQLClient(link: link, cache: InMemoryCache());

  final subscription = """
  subscription sub {
    block_aggregate {
      aggregate {
        count
      }
    }
  }
  """;

  client.subscribe(Operation(documentNode: gql(subscription))).listen((event) {
    print(event.data);
  });

  await new Future.delayed(const Duration(seconds : 15));
}
