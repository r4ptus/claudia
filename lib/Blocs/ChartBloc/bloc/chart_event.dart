part of 'chart_bloc.dart';

@immutable
abstract class ChartEvent extends Equatable {}
class LoadChart extends ChartEvent{
  final DateTime time;

  LoadChart(this.time);
  @override
  // TODO: implement props
  List<Object> get props => [time];
}
