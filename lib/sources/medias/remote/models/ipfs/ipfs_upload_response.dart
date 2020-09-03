import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ipfs_upload_response.g.dart';

/// Represents the response that is returned from an IPFS node after
/// a /api/v0/add call has ended properly.
@immutable
@JsonSerializable(explicitToJson: true)
class IpfsUploadResponse extends Equatable {
  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Hash')
  final String hash;

  @JsonKey(name: 'Size')
  final String size;

  IpfsUploadResponse({
    @required this.name,
    @required this.hash,
    @required this.size,
  })  : assert(name != null),
        assert(hash != null),
        assert(size != null);

  @override
  List<Object> get props => [name, hash, size];

  factory IpfsUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$IpfsUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IpfsUploadResponseToJson(this);
}
