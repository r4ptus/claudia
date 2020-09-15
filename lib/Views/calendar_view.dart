import 'package:claudia/Blocs/CalendarBloc/bloc/calendar_bloc.dart';
import 'package:claudia/Models/periodEntry.dart';
import 'package:claudia/Views/chart_view.dart';
import 'package:claudia/Views/info_view.dart';
import 'package:claudia/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  final String title;

  CalendarView({Key key, this.title}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarController _calendarController;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List> _holidays = {};
  Map<DateTime, List> _events = {};

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    var _calendarBloc = BlocProvider.of<CalendarBloc>(context);
    _calendarBloc.add(AddEntry());
  }

  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                MdiIcons.finance,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => ChartView(
                        time: _selectedDay,
                      ))))
        ],
      ),
      body: blocBuilder(),
      backgroundColor: Colors.pink[50],
    );
  }

  Widget blocBuilder() {
    return BlocBuilder<CalendarBloc, CalendarState>(
        //cubit: _calendarBloc,
        builder: (context, state) {
      if (state is CalendarLoaded) {
        _holidays.clear();
        _events.clear();
        state.entries.forEach((element) {
          _holidays[element.dateTime] = ["Periode"];
        });
        state.events.forEach((element) {
          _events[element.dateTime] = element.list;
        });
        return body(state.entry);
      }
      if (state is CalendarDayChanged) {
        return body(state.entry);
      }
      if (state is CalendarLoading)
        return Center(child: CircularProgressIndicator());
      return Center(child: CircularProgressIndicator());
    });
  }

  Widget body(PeriodEntry entry) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [calendar(), infoField(entry)],
    );
  }

  Widget calendar() {
    return Container(
        child: TableCalendar(
      locale: 'de-DE',
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialSelectedDay: _selectedDay,
      holidays: _holidays,
      events: _events,
      calendarStyle: CalendarStyle(
        weekendStyle: TextStyle(color: Colors.green),
        outsideWeekendStyle: TextStyle(color: Colors.green[300]),
        selectedColor: Colors.pink[300],
        todayColor: Colors.pink[100],
        markersColor: Colors.pink[700],
        outsideDaysVisible: true,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.green[800]),
      ),
      onDayLongPressed: _onDayLongPressed,
      onDaySelected: _onDayPressed,
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(Positioned(child: _buildEventMarkers(date, events)));
          }

          return children;
        },
      ),
    ));
  }

  Widget _buildEventMarkers(DateTime time, List events) {
    if (_events[DateTime(time.year, time.month, time.day)][0] == "New Period") {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.pink[800],
        ),
        width: 10,
        height: 10,
      );
    } else
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        width: 10,
        height: 10,
      );
  }

  void _onDayLongPressed(dateTime, list) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (context) => InfoView(
                  title: DateFormat("dd.MM.yyyy").format(dateTime),
                  time: dateTime,
                )))
        .then((value) {
      var _calendarBloc = BlocProvider.of<CalendarBloc>(context);
      _calendarBloc.add(Reload());
    });
  }

  void _onDayPressed(dateTime, list) {
    _selectedDay = dateTime;
    var _calendarBloc = BlocProvider.of<CalendarBloc>(context);
    _calendarBloc.add(DayChanged(dateTime));
  }

  Widget infoField(PeriodEntry entry) {
    return Container(
        height: 35 * SizeConfig.blockSizeVertical,
        width: 95 * SizeConfig.blockSizeHorizontal,
        child: Card(
          child: isPeriod(entry),
        ));
  }

  Widget isPeriod(PeriodEntry entry) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(8),
            child: Text(DateFormat("dd.MM.yyyy").format(entry.dateTime))),
        Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Temperatur:"),
                  Text("${entry?.temp ?? 0}°C")
                ])),
        Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Stimmung:"),
                  entry?.stimmung == ""
                      ? Container()
                      : Image.asset(
                          entry?.stimmung,
                          width: 30,
                          height: 30,
                          errorBuilder: (context, object, trace) => Text(""),
                        )
                ])),
        Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Symptome:"), Text("${entry?.symptome}")])),
        Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Ausfluss:"), Text("${entry?.ausfluss}")])),
        Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Notiz:"), Text(entry?.notiz)])),
      ],
    );
  }
}
