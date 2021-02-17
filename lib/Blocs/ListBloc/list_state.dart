part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {}

class ListLoading extends ListState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ListLoaded extends ListState {
  final List<PeriodEntry> list;

  ListLoaded(this.list);
  @override
  // TODO: implement props
  List<Object> get props => [list];
}
