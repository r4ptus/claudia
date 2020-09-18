import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:claudia/Models/events.dart';
import 'package:claudia/Models/periodEntry.dart';
import 'package:claudia/Models/staticVariables.dart';
import 'package:claudia/database/entryDOA.dart';
import 'package:claudia/database/eventsDOA.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc() : super(InfoInitial());

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {
    yield InfoInitial();
    if (event is LoadAddEntry) {
      EntryDOA doa = EntryDOA();

      PeriodEntry newEntry = new PeriodEntry(
          dateTime:
              new DateTime(event.time.year, event.time.month, event.time.day),
          istPeriode: StaticVariables.isPeriod,
          stimmung: "");

      await doa.insertEntry(newEntry);

      List<PeriodEntry> entries = await doa.getEntries();

      PeriodEntry entry = entries.firstWhere((element) =>
          element.dateTime.compareTo(new DateTime(
              event.time.year, event.time.month, event.time.day)) ==
          0);

      yield InfoLoaded(entry);
    }
    if (event is SymptomeChanged) {
      yield InfoSymptomChanged(event.symptome);
    }
    if (event is StimmungChanged) {
      yield InfoStimmungChanged(event.stimmung);
    }
    if (event is AusflussChanged) {
      yield InfoAusflussChanged(event.ausfluss);
    }
    if (event is PeriodeChanged) {

      yield InfoPeriodChanged(!event.isPeriod);
    }
    if (event is SaveEntry) {
      EntryDOA doa = EntryDOA();

      if (event.changed != StaticVariables.isPeriod) {
        if (!StaticVariables.isPeriod) {
          EventsDOA events = EventsDOA();
          events.insertEvent(new Events(
              event.entry.dateTime.add(new Duration(days: 13)), ["Eisprung"]));
          events.insertEvent(new Events(
              event.entry.dateTime.add(new Duration(days: 27)),
              ["New Period"]));
        }
        StaticVariables.isPeriod = !StaticVariables.isPeriod;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isPeriod', StaticVariables.isPeriod);

      await doa.updateEntry(event.entry);

      List<PeriodEntry> entries = await doa.getEntries();

      print(entries.toString());

      yield InfoPeriodSaved();
    }
  }
}
