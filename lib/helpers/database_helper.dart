import 'package:flutter_test_strat_plus/models/MarvelResponseModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  DatabaseHelper._privateConstructor();
  
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    await deleteDatabase(path);
    return await openDatabase(
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

  // Aquí puedes agregar tus funciones para operaciones en la base de datos

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
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      description TEXT, 
      modified TEXT,
      FOREIGN KEY (thumbnailId) REFERENCES Thumbnail(thumbnailId)  
    )
    """);
  }


  Future<int> insertThumbnail(Thumbnail thumbnail,int thumbnailId)async{
    return await _database!.insert(
      "Thumbnail", {
        "path":thumbnail.path,
        "extension":thumbnail.extension,
      }
    );
  }

  Future<int> insertCharacter(Character character,int thumbnailId)async{
    return await _database!.insert(
      "Character", {
        "id":character.id,
        "name":character.name,
        "description":character.description,
        "modified":character.modified,
        "thumbnailId":thumbnailId
      }
    );
  }
  
}