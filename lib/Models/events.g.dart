// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Events _$EventsFromJson(Map<String, dynamic> json) {
  return Events(
    json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
    json['list'] as List,
  );
}

Map<String, dynamic> _$EventsToJson(Events instance) => <String, dynamic>{
      'date_time': instance.dateTime?.toIso8601String(),
      'list': instance.list,
    };
