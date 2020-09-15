import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:claudia/Models/events.dart';
import 'package:claudia/Models/periodEntry.dart';
import 'package:claudia/Models/staticVariables.dart';
import 'package:claudia/database/entryDOA.dart';
import 'package:claudia/database/eventsDOA.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarLoading());

  @override
  Stream<CalendarState> mapEventToState(
    CalendarEvent event,
  ) async* {
    yield CalendarInitial();
    if (event is AddEntry) {
      EntryDOA entries = EntryDOA();
      EventsDOA events = EventsDOA();
      DateTime now = DateTime.now();
      DateTime dateTime = new DateTime(now.year, now.month, now.day);
      PeriodEntry entry = new PeriodEntry(
          dateTime: dateTime, istPeriode: StaticVariables.isPeriod,stimmung: "",ausfluss: "",symptome: "Keine", temp: 0);

      await entries.insertEntry(entry);

      List<PeriodEntry> list = await entries.getEntries();
      List<Events> event = await events.getEvents();

      yield CalendarLoaded(
          list.where((element) => element.istPeriode == true).toList(),
          event,
          list.firstWhere(
              (element) => element.dateTime.compareTo(dateTime) == 0,
              orElse: () => null));
    }
    if (event is DayChanged) {
      EntryDOA entries = EntryDOA();
      List<PeriodEntry> list = await entries.getEntries();
      DateTime dateTime = new DateTime(event.time.year, event.time.month, event.time.day);
      yield CalendarDayChanged(list.firstWhere(
          (element) => element.dateTime.compareTo(dateTime) == 0,
          orElse: () =>
              new PeriodEntry(dateTime: event.time, temp: 0, notiz: "",stimmung: "",ausfluss: "",symptome: "Keine")));
    }
    if(event is Reload){
      EntryDOA entries = EntryDOA();
      EventsDOA events = EventsDOA();
      DateTime now = DateTime.now();
      DateTime dateTime = new DateTime(now.year, now.month, now.day);

      List<PeriodEntry> list = await entries.getEntries();
      List<Events> event = await events.getEvents();

      yield CalendarLoaded(
          list.where((element) => element.istPeriode == true).toList(),
          event,
          list.firstWhere(
              (element) => element.dateTime.compareTo(dateTime) == 0,
              orElse: () => null));
    }
  }
}
