import 'package:desmosdemo/sources/sources.dart';

/// Allows to convert the events received from the chain into a list
/// of [ChainEvent] objects.
class ChainEventsConverter {
  static const ACTION_CREATE_POST = "create_post";
  static const ACTION_LIKE_POST = "like_post";
  static const ACTION_UNLIKE_POST = "unlike_post";

  static const EVENT_TYPE_POST_CREATED = "post_created";
  static const EVENT_TYPE_POST_LIKED = "post_liked";
  static const EVENT_TYPE_POST_UNLIKED = "post_unliked";

  static const POST_ID = "post_id";
  static const POST_PARENT_ID = "post_parent_id";
  static const POST_OWNER = "post_owner";

  static const LIKE_OWNER = "liker";

  /// Converts the given [events] map into a list of [ChainEvent] objects.
  List<ChainEvent> convert(Map<String, List<String>> events) {
    if (events.isEmpty) {
      // No events, return an empty list
      return [];
    }

    // Create a map telling which converter should be used for each action
    final Map<String, Function(int, Map<String, List<String>>)> converters = {
      ACTION_CREATE_POST: _convertPostCreatedEvents,
      ACTION_LIKE_POST: _convertPostLikedEvents,
      ACTION_UNLIKE_POST: _convertPostUnlikedEvent,
    };

    final List<ChainEvent> chainEvents = [];

    // Iterate over all the converters and apply them to
    // get the converted values
    converters.forEach((action, converter) {
      final convertedEvents = _convertEvents(action, events, converter);
      chainEvents.addAll(convertedEvents);
    });

    return chainEvents;
  }

  /// Takes the emitted chain [events] that are associated with the given
  /// [action]. Then applies the [converter] function on each of them and
  /// returns the overall resulting list.
  List<ChainEvent> _convertEvents(
    String action,
    Map<String, List<String>> events,
    Function(int, Map<String, List<String>>) converter,
  ) {
    // Get the events of the given action
    final List<String> actions =
        events["message.action"].where((a) => a == action).toList();

    // Convert each event
    final List<ChainEvent> chainEvents = [];

    for (int index = 0; index < actions.length; index++) {
      final converted = converter(index, events);
      if (converted != null) {
        chainEvents.add(converted);
      }
    }

    return chainEvents;
  }

  ChainEvent _convertPostCreatedEvents(
    int index,
    Map<String, List<String>> events,
  ) {
    if (!events.containsKey("$EVENT_TYPE_POST_CREATED.$POST_ID")) {
      return null;
    }

    return PostCreatedEvent(
      postId: events["$EVENT_TYPE_POST_CREATED.$POST_ID"][index],
      parentId: events["$EVENT_TYPE_POST_CREATED.$POST_PARENT_ID"][index],
      owner: events["$EVENT_TYPE_POST_CREATED.$POST_OWNER"][index],
    );
  }

  ChainEvent _convertPostLikedEvents(
    int index,
    Map<String, List<String>> events,
  ) {
    if (!events.containsKey("$EVENT_TYPE_POST_LIKED.$POST_ID")) {
      return null;
    }

    return PostLikedEvent(
      postId: events["$EVENT_TYPE_POST_LIKED.$POST_ID"][index],
      liker: events['$EVENT_TYPE_POST_LIKED.$LIKE_OWNER'][index],
    );
  }

  ChainEvent _convertPostUnlikedEvent(
    int index,
    Map<String, List<String>> events,
  ) {
    if (!events.containsKey("$EVENT_TYPE_POST_UNLIKED.$POST_ID")) {
      return null;
    }

    return PostUnlikedEvent(
      postId: events["$EVENT_TYPE_POST_UNLIKED.$POST_ID"][index],
      liker: events['$EVENT_TYPE_POST_UNLIKED.$LIKE_OWNER'][index],
    );
  }
}
