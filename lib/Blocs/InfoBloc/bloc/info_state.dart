part of 'info_bloc.dart';

@immutable
abstract class InfoState extends Equatable {}

class InfoInitial extends InfoState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class InfoLoaded extends InfoState{
  final PeriodEntry entry;

  InfoLoaded(this.entry);

  @override
  // TODO: implement props
  List<Object> get props => [entry];
}
class InfoSymptomChanged extends InfoState{
  final List symptome;

  InfoSymptomChanged(this.symptome);

  @override
  // TODO: implement props
  List<Object> get props => [symptome];
}
class InfoStimmungChanged extends InfoState{
  final String stimmung;

  InfoStimmungChanged(this.stimmung);

  @override
  // TODO: implement props
  List<Object> get props => [stimmung];
}
class InfoAusflussChanged extends InfoState{
  final String ausfluss;

  InfoAusflussChanged(this.ausfluss);

  @override
  // TODO: implement props
  List<Object> get props => [ausfluss];
}
class InfoPeriodChanged extends InfoState{
  final bool periodChanged;

  InfoPeriodChanged(this.periodChanged);
  @override
  // TODO: implement props
  List<Object> get props => [periodChanged];
}
class InfoPeriodSaved extends InfoState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
