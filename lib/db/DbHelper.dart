import 'package:flutter_localnotification/Models/TaskModels.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";
  static int? id;
  static String? title;
  static String? note;
  static String? date;
  static String? startTime;
  static String? endTime;
  static int? remind;
  static String? repeat;
  static int? isCompleted;

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      void _onUpgrade(Database db, int oldVersion, int newVersion) {
        if (oldVersion < newVersion) {
          print("Db Upgraded");
          // db.execute("ALTER TABLE $_tableName ADD COLUMN userID INTEGER;");
        }
      }

      String _path = await getDatabasesPath() + 'tasks.db';
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print("Creating New Db");
        return db.execute("CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title STRING,note TEXT,date STRING , "
            "startTime STRING,endTime STRING,"
            "remind INTEGER,repeat STRING,isCompleted INTEGER )");
      }, onUpgrade: _onUpgrade);
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(TaskData? task) async {
    print("Insert Function Called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static delete(TaskData task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async{
    // await _db!.update(_tableName,
    //     {
    //       "title": title,
    //       "note": note,
    //       "date": date,
    //       "startTime": startTime,
    //       "endTime": endTime,
    //       "remind": remind,
    //       "repeat": repeat,
    //       "isCompleted": isCompleted,
    //     },
    //     where: 'id=?',
    //     whereArgs: [id]);

   return await _db?.rawUpdate('''
    UPDATE $_tableName SET isCompleted = ? WHERE id=? 
    ''' , [1,id]);
  }
}
