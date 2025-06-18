import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static final HttpLink httpLink = HttpLink('https://api-kobessah.biscuit.my.id/');

  static final AuthLink authLink = AuthLink(
    getToken: () async {
      final box = GetStorage();
      final token = box.read('token');
      return token != null ? 'Bearer $token' : null;
    },
  );

  static final Link link = authLink.concat(httpLink);

  static final GraphQLClient client = GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );

  static Future<QueryResult> mutate(String mutation,
      {Map<String, dynamic>? variables}) async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: variables ?? {},
        ),
      );

      if (kDebugMode) {
        print("Mutation result: ${result.data}");
        print("Mutation errors: ${result.exception?.graphqlErrors}");
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print("GraphQL mutation error: $e");
      }
      rethrow;
    }
  }
}
