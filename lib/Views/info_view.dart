import 'dart:ui';

import 'package:claudia/Blocs/InfoBloc/bloc/info_bloc.dart';
import 'package:claudia/Models/periodEntry.dart';
import 'package:claudia/Models/staticVariables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class InfoView extends StatefulWidget {
  final String title;
  final DateTime time;
  InfoView({Key key, this.title, this.time}) : super(key: key);

  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  TextEditingController _textEditingController;
  TextEditingController _textEditingControllerTemp;
  PeriodEntry entry;
  String ausflussValue;
  String stimmungValue;
  List moods = [
    "assets/images/grinning-face_1f600.png",
    "assets/images/face-with-steam-from-nose_1f624.png",
    "assets/images/confused-face_1f615.png",
    "assets/images/crying-face_1f622.png"
  ];
  List myActivities;
  bool periodChanged;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingControllerTemp = TextEditingController();

    _textEditingController.text = "";
    _textEditingControllerTemp.text = "";
    myActivities = [];
    ausflussValue = "";
    stimmungValue = "";
    periodChanged = StaticVariables.isPeriod;

    var _infoBloc = BlocProvider.of<InfoBloc>(context);
    _infoBloc.add(LoadAddEntry(widget.time));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: () {
                entry.ausfluss = ausflussValue;
                entry.stimmung = stimmungValue;
                entry.symptome = myActivities.toString();
                entry.istPeriode = periodChanged;
                entry.notiz = _textEditingController.text;
                entry.temp =
                    double.tryParse(_textEditingControllerTemp.text) ?? 0;

                var _infoBloc = BlocProvider.of<InfoBloc>(context);
                _infoBloc.add(SaveEntry(entry,periodChanged));
              },
              child: Text(
                "save",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
        ],
      ),
      body: blocBuilder(),
      backgroundColor: Colors.pink[50],
    );
  }

  Widget blocBuilder() {
    return BlocConsumer<InfoBloc, InfoState>(listener: (context, state) {
      if (state is InfoPeriodSaved) Navigator.of(context).pop();
    }, builder: (context, state) {
      if (state is InfoLoaded) {
        entry = state.entry;
        _textEditingController.text = entry.notiz?.toString() ?? "";
        _textEditingControllerTemp.text = entry.temp?.toString() ?? "";

        ausflussValue = entry.ausfluss ?? "";
        stimmungValue = entry.stimmung ?? "";
        return body();
      }
      if (state is InfoSymptomChanged) {
        myActivities = state.symptome;
        return body();
      }
      if (state is InfoAusflussChanged) {
        ausflussValue = state.ausfluss;
        return body();
      }
      if (state is InfoStimmungChanged) {
        stimmungValue = state.stimmung;
        return body();
      }
      if (state is InfoPeriodChanged) {
        periodChanged = state.periodChanged;
        return body();
      }

      return body();
    });
  }

  Widget body() {
    return Container(
        child: SingleChildScrollView(
      child: Column(children: widgets()),
    ));
  }

  List<Widget> widgets() => [
        Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: RaisedButton(
                color: periodChanged
                    ? Colors.red[300]
                    : Colors.green[300],
                child: periodChanged
                    ? Text("Periodenende")
                    : Text("Periodenstart"),
                onPressed: () {
                  var _infoBloc = BlocProvider.of<InfoBloc>(context);
                  _infoBloc.add(PeriodeChanged(
                      periodChanged, entry.dateTime));
                },
              ),
            )),
        Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              controller: _textEditingControllerTemp,
              decoration: InputDecoration(labelText: "Temperatur"),
              keyboardType: TextInputType.number,
            )),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text("Gefühlslage"),
        ),
        GridView.count(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 4,
          shrinkWrap: true,
          children: List.generate(
              4,
              (index) => Container(
                  color:
                      stimmungValue == moods[index] ? Colors.red : Colors.pink[50],
                  child: GestureDetector(
                      onTap: () {
                        var _infoBloc = BlocProvider.of<InfoBloc>(context);
                        _infoBloc.add(StimmungChanged(moods[index]));
                      },
                      child: Image.asset(moods[index])))),
        ),
        Padding(padding: EdgeInsets.all(8), child: multiSelect()),
        Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ausfluss"),
                  DropdownButton(
                      value: ausflussValue,
                      items: <String>[
                        '',
                        'Schmierblutung',
                        'Klebrig',
                        'Eiweißartig',
                        'Wässrig'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        var _infoBloc = BlocProvider.of<InfoBloc>(context);
                        _infoBloc.add(AusflussChanged(newValue));
                      })
                ])),
        Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(labelText: "Notiz"),
            )),
      ];
  Widget multiSelect() {
    return MultiSelectFormField(
      fillColor: Colors.pink[50],
      autovalidate: false,
      titleText: "Symptome",
      dataSource: [
        {
          "display": "Keine",
          "value": "Keine",
        },
        {
          "display": "Krämpfe",
          "value": "Krämpfe",
        },
        {
          "display": "Empfindliche Brust",
          "value": "Empfindliche Brust",
        },
        {
          "display": "Kopfweh",
          "value": "Kopfweh",
        },
        {
          "display": "Akne",
          "value": "Akne",
        },
        {
          "display": "Kreuzschmerzen",
          "value": "Kreuzschmerzen",
        },
        {
          "display": "Verstopfung",
          "value": "Verstopfung",
        },
        {
          "display": "Durchfall",
          "value": "Durchfall",
        },
        {
          "display": "Unterleibschmerzen",
          "value": "Unterleibschmerzen",
        },
        {
          "display": "Ziehen im Unterbauch",
          "value": "Ziehen im Unterbauch",
        },
      ],
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      initialValue: myActivities,
      onSaved: (value) {
        var _infoBloc = BlocProvider.of<InfoBloc>(context);
        _infoBloc.add(SymptomeChanged(value));
      },
    );
  }
}
