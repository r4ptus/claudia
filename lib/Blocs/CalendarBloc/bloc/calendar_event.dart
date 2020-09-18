part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}
class LoadEntries extends CalendarEvent{
  @override
  List<Object> get props => [];
}
class AddEntry extends CalendarEvent{
  @override
  List<Object> get props => [];
}
class DayChanged extends CalendarEvent{
  final DateTime time;

  DayChanged(this.time);
  @override
  List<Object> get props => [time];
}
class Reload extends CalendarEvent{
@override
  List<Object> get props => [];
}
class PeriodeNachtragen extends CalendarEvent{
  final DateTime start;
  final DateTime end;

  PeriodeNachtragen(this.start, this.end);
  @override
  List<Object> get props => [start,end];
}
