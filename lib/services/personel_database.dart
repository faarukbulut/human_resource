import 'package:human_resource/model/personels/personel.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PersonelDatabase{
  var databaseFactory = databaseFactoryFfi;
  Database? _database;

  Future<void> open() async{
    _database = await databaseFactory.openDatabase("personel.db");
    create(_database!);
  }

  Future<void> create(Database db) async{
    await db.execute(
      "CREATE TABLE IF NOT EXISTS Personel (id INTEGER PRIMARY KEY AUTOINCREMENT, adi VARCHAR(255), il INT, ilce INT, iseGiris DATETIME, istenCikis DATETIME NULL, cepTel VARCHAR(15), email VARCHAR(255), hitap INT, kvkk BOOLEAN, unvanId INT)"
    );
  }

  Future<List> getList() async{
    List<Map<String, dynamic>> personelList = await _database!.query("Personel");
    return personelList;
  }

  Future<Map<String, dynamic>> get(int id) async {
    List<Map<String, dynamic>> results = await _database!.query("Personel", where: 'id = ?', whereArgs: [id]);
    return results.first;
  }

  Future<int> insert(Personel model) async {
    final result = await _database!.insert("Personel", model.toJson());
    return result;
  }

  Future<int> update(int id, Personel model) async{
    final result = await _database!.update("Personel", model.toJson(), where: 'id=?', whereArgs: [id]);
    return result;
  }

  Future<int> delete(int id) async{
    var result = await _database!.delete("Personel", where: 'id=?', whereArgs: [id]);
    return result;
  }

  Future<void> close() async{
    await _database!.close();
  }

}