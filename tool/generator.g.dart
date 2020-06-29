// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Selection _$SelectionFromJson(Map<String, dynamic> json) {
  return Selection(
    (json['icons'] as List)
        ?.map(
            (e) => e == null ? null : Icon.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Icon _$IconFromJson(Map<String, dynamic> json) {
  return Icon(
    json['properties'] == null
        ? null
        : Properties.fromJson(json['properties'] as Map<String, dynamic>),
  );
}

Properties _$PropertiesFromJson(Map<String, dynamic> json) {
  return Properties(
    json['name'] as String,
    json['code'] as int,
  );
}
