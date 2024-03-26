import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {

  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'data.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "data.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data =
      await rootBundle.load(join('assets/database', 'data.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getDetails() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> userList = await db.rawQuery(
        "select * from Product");
    return userList;
  }

  Future<int> insertRecord(Map<String, Object?> map) async {
    Database db = await initDatabase();
    int insert = await db.insert("Product", map);
    return insert;
  }

  Future<int> deleteUser(id) async {
    Database db = await initDatabase();
    var res = await db.delete("Product", where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<int> editUser(Map<String, Object?> map, id) async {
    Database db = await initDatabase();

    var res = await db.update(
        "Product", map, where: "id = ?", whereArgs: [id]);
    return res;
  }
}

//second method
// Future<Database> initDatabase() async {
//   return await openDatabase(
//     join(await getDatabasesPath(), 'MyDatabase.db'),
//     version: 2,
//     onCreate: (db, version) {
//       db.execute(
//           'CREATE TABLE Tbl_User(UserId INTEGER PRIMARY KEY AUTOINCREMENT, UserName TEXT)');
//     },
//     onUpgrade: (db, oldVersion, newVersion) {
//       db.execute(
//           'CREATE TABLE Tbl_User(UserId INTEGER PRIMARY KEY AUTOINCREMENT, UserName TEXT)');
//     },
//   );
// }
//
// Future<int> insertUserDetailInTblUser({required userName}) async {
//   Database db = await initDatabase();
//   Map<String, dynamic> map = {};
//   map['UserName'] = userName;
//   int pk = await db.insert('Tbl_User', map);
//   return pk;
// }
//
// Future<int> updateUserDetailInTblUser({required userName,required userId}) async {
//   Database db =await initDatabase();
//   Map<String,dynamic> map = {};
//   map['UserName'] = userName;
//   int pk = await db.update('Tbl_User', map,where: 'UserId = ?', whereArgs: [userId]);
//   return pk;
// }
//
// Future<List<Map<String, dynamic>>> getUserListFromTblUser() async {
//   Database db = await initDatabase();
//   List<Map<String, dynamic>> userList =
//   await db.rawQuery('SELECT * FROM Tbl_User');
//   return userList;
// }
//
// Future<int> deleteUserFromTblUser({required userId}) async {
//   Database db = await initDatabase();
//   int pk =
//   await db.delete('Tbl_User', where: 'UserId = ?', whereArgs: [userId]);
//   return pk;
// }