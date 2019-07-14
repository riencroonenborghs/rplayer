import "dart:async";
import "dart:io" as io;
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:path_provider/path_provider.dart";
import "package:RPlayer/models/models.dart";

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;
  String _dbFile = "rplayer.db";

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbFile);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  Future<String> deleteDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbFile);
    await deleteDatabase(path);
    // _db.close();
    _db = null;

    return path;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Bookmarks(id INTEGER PRIMARY KEY, name TEXT, network INTEGER, location TEXT, icon TEXT);");
    // print("Created tables");
  }

  Future<bool> saveBookmark(Bookmark bookmark) async {
    var dbClient = await db;
    int result = await dbClient.insert("Bookmarks", bookmark.toMap());
    return result == 1;
  }

  Future<bool> removeBookmark(Bookmark bookmark) async {
    var dbClient = await db;
    int count = await dbClient.rawDelete("delete from Bookmarks where id = ?", [bookmark.id]);
    return count == 1;
  }
  removeAllBookmarks() async {
    var dbClient = await db;
    await dbClient.rawDelete("delete from Bookmarks");
  }

  Future<List<Bookmark>> getBookmarks() async {
    var dbClient = await db;
    var res = await dbClient.query("Bookmarks");
    return res.map((bookmarkMap) => Bookmark.fromMap(bookmarkMap)).toList();
  }
}