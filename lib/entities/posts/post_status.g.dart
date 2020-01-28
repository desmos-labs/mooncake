// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostStatus _$PostStatusFromJson(Map<String, dynamic> json) {
  return PostStatus(
    value: _$enumDecodeNullable(_$PostStatusValueEnumMap, json['value']),
    error: json['error'] as String,
  );
}

Map<String, dynamic> _$PostStatusToJson(PostStatus instance) =>
    <String, dynamic>{
      'value': _$PostStatusValueEnumMap[instance.value],
      'error': instance.error,
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

const _$PostStatusValueEnumMap = {
  PostStatusValue.TO_BE_SYNCED: 'to_be_synced',
  PostStatusValue.SYNCING: 'syncing',
  PostStatusValue.SYNCED: 'synced',
  PostStatusValue.ERRORED: 'errored',
};
