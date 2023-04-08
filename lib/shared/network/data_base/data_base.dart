import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

List<Map> response=[];
class Sql {
  Database? my;
   Database? _db;
   Database? database;
   late String path;
  Future <Database> get db async{
    if (_db ==null){
      _db=await intialDb();
      return _db!;
    }else{
      return _db!;
    }

  }
  intialDb() async {
    var datBase = await getDatabasesPath();
    path = join(datBase, 'DB-G.db');
    database=await openDatabase(
      path,
      version:1 ,
      onCreate: (dataBase,no)async{
        Database myDb = await db;
        await myDb.transaction((txn) async {
          txn.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,time TEXT,date TEXT, status TEXT)');
       }).
        then((value) {
          print('Created successfully................................');
        }).catchError((error){
          print('Error while making $error');
        });
      },

      onOpen: (database){
        readData(database).then((value){
          response=value;
          print('$value opened successfully................................');
        }).catchError((error){
          print('Error while making ${error.toString()}');
        });
      },

      onUpgrade: (Database database, int oldVersion, int newVersion) {
        print('$Database upgrading..............');
      },
    );
    return database;
  }


  insertIntoDB({@required title, @required time, @required date,
  }) async {
    Database myDb = await db;
    await myDb.transaction((txn) async {
      txn.rawInsert('INSERT INTO tasks(title,time,date) VALUES($title ,$time,$date)')
      .then((value){
      print('Inserted successfully..........................');
    })
      .catchError((error){
      print('Error while making ${error.toString()}');
    });
  });}

  readData(database) async {
    Database myDb = await db;
    return await myDb.rawQuery('SELECT * FROM tasks');
  }

  updateData(String sql) async {
    Database myDb = await db;
    await myDb.rawUpdate(sql).then((value){
      print('Updated successfully................................');
    });
  }

  deleteData(String sql)  {
my?.rawDelete(sql).then((value){
      print('Deleted successfully................................');
    }).catchError((error){
      print('Error while deleting ');
    });
  }

}
