import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'block_response.g.dart';

/// Represents the response that is returned when querying a block
/// details from the chain.
@JsonSerializable(explicitToJson: true)
class BlockResponse implements Equatable {
  @JsonKey(name: "block_meta")
  final BlockMeta blockMeta;

  BlockResponse({@required this.blockMeta}) : assert(blockMeta != null);

  @override
  List<Object> get props => [blockMeta];

  @override
  String toString() => 'BlockResponse { '
      'blockMeta: $blockMeta '
      '}';

  factory BlockResponse.fromJson(Map<String, dynamic> json) =>
      _$BlockResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BlockResponseToJson(this);
}

/// Contains the metadata of a block queried from the chain.
@JsonSerializable(explicitToJson: true)
class BlockMeta implements Equatable {
  @JsonKey(name: "header")
  final BlockHeader header;

  BlockMeta({@required this.header}) : assert(header != null);

  @override
  List<Object> get props => [header];

  @override
  String toString() => 'BlockMeta { '
      'header: $header '
      '}';

  factory BlockMeta.fromJson(Map<String, dynamic> json) =>
      _$BlockMetaFromJson(json);

  Map<String, dynamic> toJson() => _$BlockMetaToJson(this);
}

/// Contains the details of the header of a block metadata queried from
/// the chain.
@JsonSerializable(explicitToJson: true)
class BlockHeader implements Equatable {
  @JsonKey(name: "height")
  final String height;

  BlockHeader({@required this.height}) : assert(height != null);

  @override
  List<Object> get props => [height];

  @override
  String toString() => 'BlockHeader { '
      'height: $height '
      '}';

  factory BlockHeader.fromJson(Map<String, dynamic> json) =>
      _$BlockHeaderFromJson(json);

  Map<String, dynamic> toJson() => _$BlockHeaderToJson(this);
}
