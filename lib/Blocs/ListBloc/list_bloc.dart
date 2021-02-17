import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:claudia/Models/periodEntry.dart';
import 'package:claudia/database/entryDOA.dart';
import 'package:equatable/equatable.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial());

  @override
  Stream<ListState> mapEventToState(
    ListEvent event,
  ) async* {
    yield ListInitial();
    if(event is LoadListEntries){
      EntryDOA doa = EntryDOA();

      List<PeriodEntry> list = (await doa.getEntries()).where((element) => element.istPeriode).toList();

      list.sort((a,b) => -a.dateTime.compareTo(b.dateTime));

      yield ListLoaded(list);
    }
    if(event is DeleteListEntry){
      EntryDOA doa = EntryDOA();

      await doa.delete(event.entry);

      List<PeriodEntry> list = (await doa.getEntries()).where((element) => element.istPeriode).toList();

      list.sort((a,b) => -a.dateTime.compareTo(b.dateTime));

      yield ListLoaded(list);
    }
  }
}
