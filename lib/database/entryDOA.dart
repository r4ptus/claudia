import 'package:claudia/Models/periodEntry.dart';
import 'package:sembast/sembast.dart';

import 'dbSembast.dart';

class EntryDOA {
  static const String folderName = "Entry";
  final _codeFolder = stringMapStoreFactory.store(folderName);

  Future<Database> get _db async => await DbSembast.instance.database;

  Future insertEntry(PeriodEntry entry) async{
    await _codeFolder.record(entry.dateTime.toString()).add(await _db, entry.toJson());
    //await _codeFolder.add(await _db, entry.toJson());
    print("Added $entry");
  }
  Future updateEntry(PeriodEntry entry) async{
    final finder = Finder(filter: Filter.byKey(entry.dateTime.toString()));
    await _codeFolder.update(await _db, entry.toJson(),finder: finder);
    print("Updated $entry");
  }
  Future delete(PeriodEntry entry) async{
    final finder = Finder(filter: Filter.byKey(entry.dateTime.toString()));
    await _codeFolder.delete(await _db, finder: finder);
  }
  Future deleteAll() async{
    await _codeFolder.delete(await _db);
  }
  Future<PeriodEntry> getEntry(DateTime dateTime) async{
    final finder = Finder(filter: Filter.byKey(dateTime.toString()));
    final entry = await _codeFolder.findFirst(await _db,finder: finder);
    
    print("${entry.value}");
    return PeriodEntry.fromJson(entry.value);
  }
  Future<List<PeriodEntry>> getEntries()async{
    final recordSnapshot = await _codeFolder.find(await _db);
    return recordSnapshot.map((snapshot){
      final route = PeriodEntry.fromJson(snapshot.value);
      return route;
    }).toList();
  }
}