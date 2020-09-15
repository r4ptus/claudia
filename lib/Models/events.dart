import 'package:json_annotation/json_annotation.dart';

part 'events.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Events {
  final DateTime dateTime;
  final List<dynamic> list;

  Events(this.dateTime, this.list);

    factory Events.fromJson(Map<String, dynamic> json) =>
      _$EventsFromJson(json);
  Map<String, dynamic> toJson() => _$EventsToJson(this);
}