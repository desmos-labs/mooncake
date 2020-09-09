import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'post_status.g.dart';

/// Represents the status of a post.
@immutable
@JsonSerializable(explicitToJson: true)
class PostStatus extends Equatable {
  @JsonKey(name: 'value')
  final PostStatusValue value;

  @JsonKey(name: 'data')
  final String data;

  const PostStatus({
    @required this.value,
    this.data,
  }) : assert(value != null);

  factory PostStatus.storedLocally(String address) {
    return PostStatus(
      value: PostStatusValue.STORED_LOCALLY,
      data: address,
    );
  }

  /// Returns true if the status contains an error message.
  bool get hasError => value == PostStatusValue.ERRORED && data != null;

  /// Returns true if the status contains a transaction hash.
  bool get hasTxHash {
    return (value == PostStatusValue.TX_SENT ||
            value == PostStatusValue.TX_SUCCESSFULL) &&
        data != null;
  }

  factory PostStatus.fromJson(Map<String, dynamic> json) {
    return _$PostStatusFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PostStatusToJson(this);
  }

  @override
  List<Object> get props {
    return [value, data];
  }

  @override
  String toString() {
    return 'PostStatus {'
        'value: $value, '
        'data: $data '
        '}';
  }
}

/// Contains the possible values of a post status.
enum PostStatusValue {
  @JsonValue('stored_locally')
  STORED_LOCALLY,
  @JsonValue('sending_tx')
  SENDING_TX,
  @JsonValue('tx_sent')
  TX_SENT,
  @JsonValue('tx_successfull')
  TX_SUCCESSFULL,
  @JsonValue('errored')
  ERRORED
}

extension PostStatusExt on PostStatusValue {
  String get value {
    return _$PostStatusValueEnumMap[this];
  }
}
