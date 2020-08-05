import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:mooncake/utils/utils.dart';

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
class GqlPostsHelper {
  static const String _postContents = """
  id
  parent_id
  subspace
  created
  hidden
  last_edited
  allows_comments
  message
  optional_data
  media: medias {
    uri
    mime_type
  }
  poll {
    question
    end_date
    allows_answer_edits
    allows_multiple_answers
    open
    available_answers {
      id: answer_id
      text: answer_text
    }
    user_answers {
      answer
      user {
        ${GqlUsersHelper.userContents}
      }
    }
  }
  reactions {
    user: owner {
      ${GqlUsersHelper.userContents}
    }
    value
  }
  user: creator {
    ${GqlUsersHelper.userContents}
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
  static Future<List<Post>> _convertPostsGqlResponse(dynamic posts) async {
    // (posts as List<dynamic>)
    //  Future<List<Post>> postsConverted = posts.map((json) {
    // Post singlePost = Post.fromJson(_convertFields(
    //     json as Map<String, dynamic>,
    //   ));

    //  RichLinkPreview linkPreview = await LinkPreviewConverter.fetchPreview(singlePost);

    //       return singlePost.copyWith(linkPreview: linkPreview);
    //     })
    //     .toList();
    // return postsConverted;
    //wingman
    List<Post> formattedPosts =
        await Future.wait((posts as List<dynamic>).map((json) async {
      Post singlePost = Post.fromJson(_convertFields(
        json as Map<String, dynamic>,
      ));
      RichLinkPreview linkPreview =
          await LinkPreviewConverter.fetchPreview(singlePost);
      return singlePost.copyWith(linkPreview: linkPreview);
    }));

    return formattedPosts;
    //wingman
    // for (var i = 0; i < posts.length; i++) {
    //   Post singlePost = Post.fromJson(_convertFields(
    //     posts[i] as Map<String, dynamic>
    //   ));

    //   RichLinkPreview linkPreview = await LinkPreviewConverter.fetchPreview(singlePost);

    // }
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
    final data = await measureExecTime(() async {
      return client.query(QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.noCache,
      ));
    }, name: "Query posts");

    return await measureExecTime(() async {
      return await compute(_convertPostsGqlResponse, data.data["posts"]);
    }, name: "Convert posts");
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
    final data = await client.query(QueryOptions(
      document: gql(query),
      fetchPolicy: FetchPolicy.noCache,
    ));
    final posts = await _convertPostsGqlResponse(data.data["post"]);
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
    final data = await client.query(QueryOptions(
      document: gql(query),
      fetchPolicy: FetchPolicy.noCache,
    ));
    return await _convertPostsGqlResponse(data.data["comments"]);
  }
}
