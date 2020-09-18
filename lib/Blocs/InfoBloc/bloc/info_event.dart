part of 'info_bloc.dart';

@immutable
abstract class InfoEvent extends Equatable {}
class LoadAddEntry extends InfoEvent{
  final DateTime time;

  LoadAddEntry(this.time);
  @override
  // TODO: implement props
  List<Object> get props => [time];
}
class SymptomeChanged extends InfoEvent{
  final List symptome;

  SymptomeChanged(this.symptome);
  @override
  // TODO: implement props
  List<Object> get props => [symptome];
}
class AusflussChanged extends InfoEvent{
  final String ausfluss;

  AusflussChanged(this.ausfluss);
  @override
  // TODO: implement props
  List<Object> get props => [ausfluss];
}
class StimmungChanged extends InfoEvent{
  final String stimmung;

  StimmungChanged(this.stimmung);
  @override
  // TODO: implement props
  List<Object> get props => [stimmung];
}
class PeriodeChanged extends InfoEvent{
  final bool isPeriod;
  final DateTime time;

  PeriodeChanged(this.isPeriod, this.time);
  @override
  // TODO: implement props
  List<Object> get props => [isPeriod];
}
class SaveEntry extends InfoEvent{
  final PeriodEntry entry;
  final bool changed;

  SaveEntry(this.entry, this.changed);
  @override
  // TODO: implement props
  List<Object> get props => [entry,changed];
}
