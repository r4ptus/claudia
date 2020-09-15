import 'package:claudia/Models/events.dart';
import 'package:sembast/sembast.dart';

import 'dbSembast.dart';

class EventsDOA {
  static const String folderName = "Events";
  final _codeFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await DbSembast.instance.database;

  Future insertEvent(Events events) async{
    await _codeFolder.add(await _db, events.toJson());
    print("Added $events");
  }
  Future delete(Events events) async{
    final finder = Finder(filter: Filter.byKey(events.dateTime));
    await _codeFolder.delete(await _db, finder: finder);
  }
  Future deleteAll() async{
    await _codeFolder.delete(await _db);
  }
  Future<Events> getEvent(DateTime dateTime) async{
    final finder = Finder(filter: Filter.byKey(dateTime.toString()));
    final entry = await _codeFolder.findFirst(await _db,finder: finder);
    
    print("${entry.value}");
    return Events.fromJson(entry.value);
  }
  Future<List<Events>> getEvents()async{
    final recordSnapshot = await _codeFolder.find(await _db);
    return recordSnapshot.map((snapshot){
      final route = Events.fromJson(snapshot.value);
      return route;
    }).toList();
  }
}