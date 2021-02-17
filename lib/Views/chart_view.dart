import 'package:claudia/Blocs/ChartBloc/bloc/chart_bloc.dart';
import 'package:claudia/Models/periodEntry.dart';
import 'package:claudia/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartView extends StatefulWidget {
  //final DateTime time;
  ChartView({Key key}) : super(key: key);

  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  List<charts.Series<Periodendauer, DateTime>> seriesList;
  static List<Periodendauer> streaks = [];
  DateTime dateTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ChartBloc>(context).add(LoadChart(DateTime.now()));
    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        if (state is ChartLoaded) {
          dateTime = state.dateTime;
          streaks = getPerioden(state.list);
          seriesList = _createSampleData(clone(state.list));
          

          return _scaffold();
        }
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _scaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat("MM.yyyy").format(dateTime)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: () {
            if (dateTime.month - 1 <= 0)
              BlocProvider.of<ChartBloc>(context).add(LoadChart(DateTime(
                dateTime.year - 1,
                12,
              )));
            else
              BlocProvider.of<ChartBloc>(context).add(LoadChart(DateTime(
                dateTime.year,
                dateTime.month - 1,
              )));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              if (dateTime.month + 1 > 12)
                BlocProvider.of<ChartBloc>(context).add(LoadChart(DateTime(
                  dateTime.year + 1,
                  1,
                )));
              else
                BlocProvider.of<ChartBloc>(context).add(LoadChart(DateTime(
                  dateTime.year,
                  dateTime.month + 1,
                )));
            },
          ),
        ],
      ),
      body: body(),
      backgroundColor: Colors.pink[50],
    );
  }

  Widget body() {
    return Container(
        child: Padding(padding: EdgeInsets.all(8), child: chart()));
  }

  Widget chart() {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: true,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(zeroBound: false)),
      behaviors: [
        charts.ChartTitle("°C",
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification: charts.OutsideJustification.endDrawArea,
            titleDirection: charts.ChartTitleDirection.horizontal),
      ],
      // Custom renderer configuration for the point series.
      customSeriesRenderers: [
        new charts.SymbolAnnotationRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customSymbolAnnotation')
      ],
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Periodendauer, DateTime>> _createSampleData(
      List<Periodendauer> list) {
    final List<Periodendauer> myDesktopData = list;

    // Example of a series with one range annotation and two single point
    // annotations. Omitting the previous and target domain values causes that
    // datum to be drawn as a single point.
    final List<Periodendauer> myAnnotationData2 = streaks;

    return [
      new charts.Series<Periodendauer, DateTime>(
        id: 'Temperatur',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Periodendauer sales, _) => sales.initial,
        measureFn: (Periodendauer sales, _) => sales.temp,
        data: myDesktopData,
      ),
      new charts.Series<Periodendauer, DateTime>(
        id: 'Annotation Series 2',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Periodendauer sales, _) => sales.end,
        domainLowerBoundFn: (Periodendauer row, _) => row.start,
        domainUpperBoundFn: (Periodendauer row, _) => row.end,
        // No measure values are needed for symbol annotations.
        measureFn: (_, __) => null,
        data: myAnnotationData2,
      )
        // Configure our custom symbol annotation renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customSymbolAnnotation')
        // Optional radius for the annotation shape. If not specified, this will
        // default to the same radius as the points.
        ..setAttribute(charts.boundsLineRadiusPxKey, 3.5),
    ];
  }

  List<Periodendauer> clone(List<PeriodEntry> list) {
    List<Periodendauer> temp = [];
    for(int i = 1; i<=DateTime(dateTime.year,dateTime.month + 1,0).day;i++){
      temp.add(new Periodendauer(initial: new DateTime(dateTime.year,dateTime.month,i),temp: 0));
    }
    list.forEach((element) {
      temp.add(
          new Periodendauer(initial: element.dateTime, temp: element.temp));
    });
    return temp;
  }

  List<Periodendauer> getPerioden(List<PeriodEntry> list) {
    DateTime start;
    DateTime end;
    bool streak = false;
    List<Periodendauer> ret = [];
    list.forEach((element) {
      if (element.istPeriode) {
        if (streak) {
          end = element.dateTime;
        } else {
          streak = true;
          start = element.dateTime;
          end = element.dateTime;
        }
      } else if (streak) {
        streak = false;
        ret.add(new Periodendauer(start: start, end: end));
      }
    });
    if (ret.length == 0 && streak) {
      ret.add(new Periodendauer(start: start, end: end));
    }
    return ret;
  }
}

class Periodendauer {
  final DateTime initial;
  final DateTime start;
  final DateTime end;
  final double temp;

  Periodendauer({this.start, this.end, this.temp, this.initial});
}
