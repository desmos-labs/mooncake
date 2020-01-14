import 'package:mooncake/sources/sources.dart';

/// Convenient type that represents a converter for a list of attributes
/// into a list of ChainEvent.
typedef EventConverter = List<ChainEvent> Function(
    String, List<Map<String, String>>);

/// Allows to convert the events received from the chain into a list
/// of [ChainEvent] objects.
class ChainEventsConverter {
  static const EVENT_POST_CREATED = "post_created";
  static const EVENT_POST_LIKED = "post_liked";
  static const EVENT_POST_UNLIKED = "post_unliked";

  /// Converts the given [events] into a list of [ChainEvent] objects.
  List<ChainEvent> convert(String height, List<MsgEvent> events) {
    if (events.isEmpty) {
      // No events, return an empty list
      return [];
    }

    // Create a map telling which converter should be used for each action
    final Map<String, EventConverter> converters = {
      EVENT_POST_CREATED: _convertPostCreatedEvents,
      EVENT_POST_LIKED: _convertPostLikedEvents,
      EVENT_POST_UNLIKED: _convertPostUnlikedEvent,
    };

    final List<ChainEvent> chainEvents = [];

    // Iterate over all the converters and apply them to
    // get the converted values
    for (int index = 0; index < converters.length; index++) {
      final type = converters.keys.toList()[index];
      final converter = converters.values.toList()[index];

      final msg = events.firstWhere((e) => e.type == type, orElse: () => null);
      if (msg != null) {
        chainEvents.addAll(converter(height, msg.attributes));
      }
    }

    return chainEvents;
  }

  /// Converts the given [attrs] for the block at the given [height]
  /// into a list of [PostCreatedEvent].
  List<ChainEvent> _convertPostCreatedEvents(
    String height,
    List<Map<String, String>> attrs,
  ) {
    List<ChainEvent> events = [];
    for (int index = 0; index < attrs.length; index += 4) {
      events.add(PostCreatedEvent(
        height: height,
        postId: attrs[index]["value"],
        parentId: attrs[index + 1]["value"],
        owner: attrs[index + 3]["value"],
      ));
    }
    return events;
  }

  /// Converts the given [attrs] for the block at the given [height]
  /// into a list of [PostLikedEvent].
  List<ChainEvent> _convertPostLikedEvents(
    String height,
    List<Map<String, String>> attrs,
  ) {
    List<ChainEvent> events = [];
    for (int index = 0; index < attrs.length; index += 2) {
      events.add(PostLikedEvent(
        height: height,
        postId: attrs[index]["value"],
        liker: attrs[index + 1]["value"],
      ));
    }
    return events;
  }

  /// Converts the given [attrs] for the block at the given [height]
  /// into a list of [PostUnlikedEvent].
  List<ChainEvent> _convertPostUnlikedEvent(
    String height,
    List<Map<String, String>> attrs,
  ) {
    List<ChainEvent> events = [];
    for (int index = 0; index < attrs.length; index += 2) {
      events.add(PostUnlikedEvent(
        height: height,
        postId: attrs[index]["value"],
        liker: attrs[index + 1]["value"],
      ));
    }
    return events;
  }
}
