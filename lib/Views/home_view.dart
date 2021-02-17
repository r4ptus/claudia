import 'package:claudia/Views/calendar_view.dart';
import 'package:claudia/Views/chart_view.dart';
import 'package:claudia/Views/list_view.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedItem = 1;

  static List<Widget> _widgets = <Widget>[
    PeriodListView(),
    CalendarView(),
    ChartView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgets[_selectedItem]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Liste",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Kalender",
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.finance),
            label: "Graph",
          ),
        ],
        currentIndex: _selectedItem,
        selectedItemColor: Colors.pink,
        onTap: _onTap,
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      _selectedItem = index;
    });
  }
}
