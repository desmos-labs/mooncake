import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

/// Contains the possible values in settings.
enum PostStatusValue {
  @JsonValue("txAmount")
  TX_AMOUNT,
  @JsonValue("backupPopupPermission")
  BACKUP_POPUP_PERMISSION,
}
