import 'package:desmosdemo/sources/sources.dart';

class ChainEventsConverter {
  static const ACTION_CREATE_POST = "create_post";

  static const EVENT_TYPE_POST_CREATED = "post_created";

  static const POST_ID = "post_id";
  static const POST_PARENT_ID = "post_parent_id";
  static const POST_OWNER = "post_owner";

  List<ChainEvent> convert(Map<String, List<String>> events) {
    if (events.isEmpty) {
      // No events, return an empty list
      return [];
    }

    return _convertCreatePostEvents(events);
  }

  List<ChainEvent> _convertCreatePostEvents(Map<String, List<String>> events) {
    final int createPostEventsLength = events["message.action"]
        .where((action) => action == ACTION_CREATE_POST)
        .length;

    final List<ChainEvent> createPostEvents = [];

    for (int index = 0; index < createPostEventsLength; index++) {
      createPostEvents.add(CreatePostEvent(
        postId: events["$EVENT_TYPE_POST_CREATED.$POST_ID"][index],
        parentId: events["$EVENT_TYPE_POST_CREATED.$POST_PARENT_ID"][index],
        owner: events["$EVENT_TYPE_POST_CREATED.$POST_OWNER"][index],
      ));
    }

    return createPostEvents;
  }
}
