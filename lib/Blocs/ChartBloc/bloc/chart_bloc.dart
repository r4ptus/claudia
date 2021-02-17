import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:claudia/Models/periodEntry.dart';
import 'package:claudia/database/entryDOA.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  ChartBloc() : super(ChartInitial());

  @override
  Stream<ChartState> mapEventToState(
    ChartEvent event,
  ) async* {
    yield ChartInitial();
    if (event is LoadChart) {
      EntryDOA doa = EntryDOA();

      List<PeriodEntry> list = await doa.getEntries();

      yield ChartLoaded(list.where((element) =>
          element.dateTime.year == event.time.year &&
          element.dateTime.month == event.time.month).toList(),event.time);
    }
  }
}
