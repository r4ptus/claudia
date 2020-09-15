part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState extends Equatable {
  const CalendarState();
  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {

  @override
  List<Object> get props => [];
}
class CalendarLoading extends CalendarState {

  @override
  List<Object> get props => [];
}
class CalendarLoaded extends CalendarState {
  final List<PeriodEntry> entries;
  final List<Events> events;
  final PeriodEntry entry;

  const CalendarLoaded(this.entries, this.events, this.entry);

  @override
  List<Object> get props => [entries,events,entry];
}
class CalendarDayChanged extends CalendarState{
  final PeriodEntry entry;

  CalendarDayChanged(this.entry);

  @override
  List<Object> get props => [entry];
}

