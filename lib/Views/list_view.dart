import 'package:claudia/Blocs/ListBloc/list_bloc.dart';
import 'package:claudia/Models/periodEntry.dart';
import 'package:claudia/Views/info_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PeriodListView extends StatefulWidget {
  PeriodListView({Key key}) : super(key: key);

  @override
  _PeriodListViewState createState() => _PeriodListViewState();
}

class _PeriodListViewState extends State<PeriodListView> {
  List<PeriodEntry> entries = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ListBloc>(context).add(LoadListEntries());
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text("Perioden Tage"),
        centerTitle: true,
      ),
      body: _blocBuilder(),
      backgroundColor: Colors.pink[50],
    );
    return scaffold;
  }

  Widget _blocBuilder() {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        if (state is ListLoaded) {
          entries = state.list;
          return _body();
        }
        return Container(
          color: Colors.pink[50],
        );
      },
    );
  }

  Widget _body() => ListView.builder(
        itemBuilder: (context, index) => _periodEntry(entries[index], index),
        itemCount: entries.length,
      );

  Widget _periodEntry(PeriodEntry entry, int index) => Dismissible(
        key: Key(entry.toString()),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) async {
          final bool result = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Eintrag Löschen"),
              content: Text("Soll der eintrag gelöscht werden?"),
              actions: [
                TextButton(
                    onPressed: () {
                      BlocProvider.of<ListBloc>(context).add(LoadListEntries());
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      entries.removeAt(index);
                      BlocProvider.of<ListBloc>(context)
                          .add(DeleteListEntry(entry));
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"))
              ],
            ),
          );
          return result;
        },
        child: Card(
          child: ListTile(
            title: Text(
              DateFormat("dd.MM.yyyy").format(entry.dateTime),
            ),
            onTap: () => _entryOnTap(entry.dateTime),
          ),
        ),
      );

  _entryOnTap(DateTime time) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfoView(
            time: time,
            title: DateFormat("dd.MM.yyyy").format(time),
          ),
        ),
      );
}
