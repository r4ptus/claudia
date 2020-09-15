part of 'chart_bloc.dart';

@immutable
abstract class ChartState extends Equatable {}

class ChartInitial extends ChartState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ChartLoading extends ChartState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ChartLoaded extends ChartState{
  final List<PeriodEntry> list;

  ChartLoaded(this.list);
  @override
  // TODO: implement props
  List<Object> get props => [list];
}