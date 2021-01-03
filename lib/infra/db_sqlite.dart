import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBSQLite {
  Database _instance;
  final versionDB = 1;

  static final DBSQLite _db = DBSQLite._internal();

  DBSQLite._internal();

  factory DBSQLite() {
    return _db;
  }

  Future<Database> getInstance() async {
    if (_instance == null) _instance = await _openDatabase();

    return _instance;
  }

  Future<Database> _openDatabase() async {
    var pathDB = await getDatabasesPath();

    var sqlite = openDatabase(
      join(pathDB, 'crud_user.db'),
      version: versionDB,
      onCreate: (db, version) {
        print('onCreate $version');
        return db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,            
            document TEXT,
            email TEXT,
            age INTEGER,
            active INTEGER,
            cep TEXT,
            endereco TEXT,
            numero TEXT,
            bairro TEXT,
            cidade TEXT,
            uf TEXT,
            pais TEXT
          )        
        ''');
      },
    );
    return sqlite;
  }
}
