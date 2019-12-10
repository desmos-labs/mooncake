// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'] as String,
    message: json['message'] as String,
    created: json['created'] as String,
    owner: json['owner'] as String,
    parentId: json['parentId'] as String,
    lastEdited: json['lastEdited'] as String,
    allowsComments: json['allowsComments'] as bool,
    externalReference: json['externalReference'] as String,
    ownerIsUser: json['owner_is_user'] as bool,
    likes: (json['likes'] as List)
        ?.map(
            (e) => e == null ? null : Like.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    liked: json['liked'] as bool,
    commentsIds:
        (json['comments_ids'] as List)?.map((e) => e as String)?.toList(),
    status: _$enumDecodeNullable(_$PostStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'message': instance.message,
      'created': instance.created,
      'lastEdited': instance.lastEdited,
      'allowsComments': instance.allowsComments,
      'externalReference': instance.externalReference,
      'owner': instance.owner,
      'owner_is_user': instance.ownerIsUser,
      'liked': instance.liked,
      'likes': instance.likes?.map((e) => e?.toJson())?.toList(),
      'comments_ids': instance.commentsIds,
      'status': _$PostStatusEnumMap[instance.status],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$PostStatusEnumMap = {
  PostStatus.TO_BE_SYNCED: 'to_be_synced',
  PostStatus.SYNCING: 'syncing',
  PostStatus.SYNCED: 'synced',
};
