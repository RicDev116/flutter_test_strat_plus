import 'dart:developer';

import 'package:flutter_test_strat_plus/models/marvel_response_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


///A singleton class to handle the database
class DatabaseHelper {

  DatabaseHelper._privateConstructor(){
    _initDatabase();
  }
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _initDatabase();
    return _database!;
  }


  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    await deleteDatabase(path);
    _database = await openDatabase(
      path, 
      version: 1, 
      onOpen: (db) {
        db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
    await createTableThumbnail(db);
    await createTableCharacters(db);
  }


  Future<void> createTableThumbnail(Database db) async{
    await db.execute("""
    CREATE TABLE Thumbnail (
      thumbnailId INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT,
      extension TEXT 
    )
    """); 
  }

  Future<void> createTableCharacters(Database db)async{
    await db.execute("""
    CREATE TABLE Character (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT, 
      description TEXT, 
      modified TEXT,
      thumbnailId INTEGER,  
      FOREIGN KEY (thumbnailId) REFERENCES Thumbnail(thumbnailId)  
    )
    """);
  }


  Future<int> insertThumbnail(Thumbnail thumbnail)async{
    return await _database!.insert(
      "Thumbnail", {
        "path":thumbnail.path,
        "extension":thumbnail.extension,
      }
    );
  }

  Future<int> insertCharacter(Character character,int? thumbnailId)async{
    return await _database!.insert(
      "Character", {
        "name":character.name,
        "description":character.description,
        "modified":character.modified,
        "thumbnailId":thumbnailId
      }
    );
  }


  ///Query function to get the Characters from DB.
  ///You can filter the query with [initalId] or by [characterName]
  ///if no values is setted on this variables, hole the list is returned
  Future<List<Map<String, dynamic>>> getCharactersWithThumbnails({int? initalId = 0, String? characterName}) async {
  final query = """
    SELECT Character.*, Thumbnail.path, Thumbnail.extension
    FROM Character
    LEFT JOIN Thumbnail ON Character.thumbnailId = Thumbnail.thumbnailId
    ${initalId != null?"WHERE character.id > $initalId":""}
    ${characterName != null?"WHERE character.name LIKE \"%$characterName%\"":""}
    GROUP BY Character.name
  """;
  log(query);
  return await _database!.rawQuery(query);
}
  
}