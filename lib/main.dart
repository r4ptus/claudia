import 'package:claudia/Blocs/CalendarBloc/bloc/calendar_bloc.dart';
import 'package:claudia/Blocs/ChartBloc/bloc/chart_bloc.dart';
import 'package:claudia/Blocs/InfoBloc/bloc/info_bloc.dart';
import 'package:claudia/Blocs/ListBloc/list_bloc.dart';
import 'package:claudia/Models/staticVariables.dart';
import 'package:claudia/Views/calendar_view.dart';
import 'package:claudia/Views/home_view.dart';
import 'package:claudia/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getBools();
    return MultiBlocProvider(
        providers: [
          BlocProvider<CalendarBloc>(
            create: (context) => CalendarBloc(),
          ),
          BlocProvider<InfoBloc>(
            create: (context) => InfoBloc(),
          ),
          BlocProvider<ChartBloc>(
            create: (context) => ChartBloc(),
          ),
          BlocProvider<ListBloc>(
            create: (context) => ListBloc(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.pink,
            accentColor: Colors.pink[300],
          ),
          title: 'Claudia',
          home: HomeView(),
        ));
  }

  getBools() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StaticVariables.isPeriod = prefs.getBool('isPeriod') ?? false;
    print(StaticVariables.isPeriod);
  }
}
