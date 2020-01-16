import 'package:json_annotation/json_annotation.dart';

enum PostStatus {
  @JsonValue("to_be_synced")
  TO_BE_SYNCED,
  @JsonValue("syncing")
  SYNCING,
  @JsonValue("synced")
  SYNCED,
}
