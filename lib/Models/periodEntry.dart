import 'package:json_annotation/json_annotation.dart';

part 'periodEntry.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PeriodEntry{
  DateTime dateTime;
  String stimmung ="";
  String symptome = "";
  String ausfluss ="";
  String notiz = "";
  double temp = 0;
  bool istPeriode;

  PeriodEntry({this.dateTime, this.stimmung, this.symptome, this.ausfluss, this.istPeriode, this.notiz,this.temp});

  factory PeriodEntry.fromJson(Map<String, dynamic> json) =>
      _$PeriodEntryFromJson(json);
  Map<String, dynamic> toJson() => _$PeriodEntryToJson(this);
}