// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'periodEntry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeriodEntry _$PeriodEntryFromJson(Map<String, dynamic> json) {
  return PeriodEntry(
    dateTime: json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
    stimmung: json['stimmung'] as String,
    symptome: json['symptome'] as String,
    ausfluss: json['ausfluss'] as String,
    istPeriode: json['ist_periode'] as bool,
    notiz: json['notiz'] as String,
    temp: (json['temp'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PeriodEntryToJson(PeriodEntry instance) =>
    <String, dynamic>{
      'date_time': instance.dateTime?.toIso8601String(),
      'stimmung': instance.stimmung,
      'symptome': instance.symptome,
      'ausfluss': instance.ausfluss,
      'notiz': instance.notiz,
      'temp': instance.temp,
      'ist_periode': instance.istPeriode,
    };
