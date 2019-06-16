import 'package:notely/models/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class DBHelper{

  static DBHelper _dbHelper; // Singleton DB Helper
  static Database _database; // singleton DB

  String table = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colBody = 'body';

  DBHelper._instance(); //Named Constructor for Creating instance of DB helper

  factory DBHelper(){
    if(_dbHelper == null){
      _dbHelper = DBHelper._instance();
    }
    return _dbHelper;
  }

  //Get database instance
  Future<Database> get database async {
    if(_database == null){
      _database = await initDB();
    }
    return _database;
  }
  //initialize database
  Future<Database> initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    
    var noteDB = await openDatabase(path, version: 1, onCreate: _createDB);
    return noteDB;
  }
  //create data table
  void _createDB(Database db, int ver) async{
    await db.execute('CREATE TABLE $table($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT NOT NULL, $colBody TEXT NOT NULL)');
  }

  // Get all note ordered by title
  Future<List<Map<String, dynamic>>> getNoteMap() async{
    Database db = await this.database;
    var result = await db.query(table, orderBy: '$colTitle ASC');
    return result;
  }

  Future<int> insert(Note note) async{
    Database db = await this.database;
    var result = await db.insert(table, note.toDB());
    return result;
  }

  Future<int> update(Note note) async{
    var db = await this.database;
    int result = await db.update(table, note.toDB(),where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> delete(int id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> noteList = await db.rawQuery('SELECT COUNT (*) FROM $table');
    int  result = Sqflite.firstIntValue(noteList);
    return result;
  }

  Future<List<Note>> getNoteList() async{
    var noteMap = await getNoteMap();
    int count = noteMap.length;
    List<Note> noteList = List<Note>();
    for(int i =0; i< count; i++){
      noteList.add(Note.fromMap(noteMap[i]));
    }
    return noteList;
  }

  void closeDB() async{
    Database db = await this.database;
    db.close();
  }
}