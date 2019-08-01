import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
export 'package:qr_reader_app/src/models/scan_model.dart';


class DBProvider{

  static Database _database;
  static final DBProvider db = DBProvider._();

  // TODO: Private Constructor
  DBProvider._();

  // TODO: Getter Database
  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await initDB();
    return _database;

  }

  //TODO: Init DB
  initDB() async {
    //TODO: Path of the Database or Where is my Database if is created
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
          );
      }
      );
  }


    // newScanRaw and newScan is the same but diferent way to building
    // newScan is more easy to building
  //TODO: CREATE Regists Raw
  newScanRaw(ScanModel newScan) async{
    final db  = await database;
    final res = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valir) "
      "VALUES ( ${newScan.id}, '${newScan.tipo}', '${newScan.valor}' )"
    );

    return res;
  }

    //TODO: CREATE Regists Json
  newScan(ScanModel newScan) async {
    final db  = await database;
    final res = await db.insert('Scans', newScan.toJson());
    return res;
  }


  //TODO: Read/Select Regist - Get Info
  // in where = ?, the ? is for say need arguments and whereArgs is for assigned
  // Scan for ID
  Future<ScanModel> getScanId(int id) async {
      final db  = await database;
      final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

      return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  // All Scans
  Future<List<ScanModel>> getAllScans() async{
    final db  = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];

    return list;
  }

  // Scans for Type
  Future<List<ScanModel>> getTypeScans(String type) async{
    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$type'");

    List<ScanModel> list = res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];

    return list;
  }


  // TODO: Update Regist
  Future<int> updateScan(ScanModel newScan) async {
    final db  = await database;
    final res = await db.update('Scans', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id]);
    return res;
  }


  // TODO: Delete Regist
  Future<int> deleteScan(int id) async {
    final db  = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db  = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }

}