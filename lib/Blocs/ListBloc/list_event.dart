part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class LoadListEntries extends ListEvent {}

class DeleteListEntry extends ListEvent {
  final PeriodEntry entry;

  DeleteListEntry(this.entry);

  List<Object> get props => [entry];
}
