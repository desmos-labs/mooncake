import 'package:mooncake/sources/sources.dart';

/// Convenient type that represents a converter for a list of attributes
/// into a list of ChainEvent.
typedef EventConverter = List<ChainEvent> Function(
    String, List<LogEventAttribute>);

/// Allows to convert the events received from the chain into a list
/// of [ChainEvent] objects.
class ChainEventsConverter {
  static const EVENT_POST_CREATED = "post_created";
  static const EVENT_POST_REACTION_ADDED = "post_reaction_added";
  static const EVENT_POST_REACTION_REMOVED = "post_reaction_removed";

  /// Converts the given [logs] into a list of [ChainEvent] objects.
  List<ChainEvent> convert(String height, List<TransactionLog> logs) {
    // Get all the events
    final events = logs?.expand((log) => log.events) ?? [];
    if (events.isEmpty) {
      // No events, return an empty list
      return [];
    }

    // Create a map telling which converter should be used for each action
    final Map<String, EventConverter> converters = {
      EVENT_POST_CREATED: _convertPostCreatedEvents,
      EVENT_POST_REACTION_ADDED: _convertPostReactionAddedEvents,
      EVENT_POST_REACTION_REMOVED: _convertPostReactionRemovedEvents,
    };

    final List<ChainEvent> chainEvents = [];

    // Iterate over all the converters and apply them to
    // get the converted values
    for (int index = 0; index < converters.length; index++) {
      final type = converters.keys.toList()[index];
      final converter = converters.values.toList()[index];

      final event = events.firstWhere(
        (e) => e.type == type,
        orElse: () => null,
      );
      if (event != null) {
        chainEvents.addAll(converter(height, event.attributes));
      }
    }

    return chainEvents;
  }

  /// Converts the given [attrs] for the block at the given [height]
  /// into a list of [PostCreatedEvent].
  List<ChainEvent> _convertPostCreatedEvents(
    String height,
    List<LogEventAttribute> attrs,
  ) {
    List<ChainEvent> events = [];
    for (int index = 0; index < attrs.length; index += 4) {
      events.add(PostCreatedEvent(
        height: height,
        postId: attrs[index].value,
        parentId: attrs[index + 1].value,
        owner: attrs[index + 3].value,
      ));
    }
    return events;
  }

  /// Converts the given [attrs] for the block at the given [height]
  /// into a list of [PostReactionAdded].
  List<ChainEvent> _convertPostReactionAddedEvents(
    String height,
    List<LogEventAttribute> attrs,
  ) {
    List<ChainEvent> events = [];
    for (int index = 0; index < attrs.length; index += 3) {
      events.add(PostEvent(
        height: height,
        postId: attrs[index].value,
      ));
    }
    return events;
  }

  /// Converts the given [attrs] for the block at the given [height]
  /// into a list of [PostReactionRemovedEvent].
  List<ChainEvent> _convertPostReactionRemovedEvents(
    String height,
    List<LogEventAttribute> attrs,
  ) {
    List<ChainEvent> events = [];
    for (int index = 0; index < attrs.length; index += 3) {
      events.add(PostEvent(
        height: height,
        postId: attrs[index].value,
      ));
    }
    return events;
  }
}
