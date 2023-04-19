import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'cache_obj.dart';
import 'net_cache.dart';

class NetDiskCache extends NetCache {
  final String _databasePath;
  final String _databaseName;
  static const int _databaseVersion = 1;

  final String _tableName = 'httpData';
  final String _column_url = 'url';
  final String _column_urlPath = 'urlPath';
  final String _column_subKey = 'subKey';
  final String _column_data = 'data';
  final String _column_headers = 'headers';
  final String _column_statusCode = 'statusCode';
  final String _column_endTime = 'endTime';

  Database? _db;

  Future<Database?> get dataBase async {
    if (null == _db) {
      _db = await _initDataBase();
      await _clearExpiredObjects(_db);
    }
    return _db;
  }

  _initDataBase() async {
    var path = _databasePath;
    if (path.isEmpty) {
      path = await getDatabasesPath();
    }
    await Directory(path).create(recursive: true);
    path = join(path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  _createTableSql() => '''
  CREATE TABLE IF NOT EXISTS $_tableName (
        $_column_url text,
        $_column_urlPath text,
        $_column_subKey text,
        $_column_data BLOB,
        $_column_headers BLOB,
        $_column_statusCode integer,
        $_column_endTime integer,
        PRIMARY KEY ($_column_urlPath, $_column_subKey)
         )
         ''';

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createTableSql());
  }

  NetDiskCache(this._databasePath, this._databaseName) : super();

  @override
  Future<CacheObj?> cacheObjectForKey(String key, {String? subKey}) async {
    var db = await dataBase;
    if (null == db) return null;
    String where = '$_column_urlPath="$key"';
    where += ' and $_column_subKey="$subKey"';
    var list = await db.query(_tableName, where: where);
    if (list.isEmpty) return null;
    CacheObj cacheObj = CacheObj.fromJson(list.first);
    return cacheObj;
  }

  @override
  Future<bool> saveObject(CacheObj cacheObj) async {
    var db = await dataBase;
    if (null == db) return false;
    // await db.execute('ALTER TABLE $_tableName ADD $_column_urlPath text');
    // 'INSERT OR REPLACE INTO httpData (url, urlPath, subKey, statusCode, endTime, headers, data) VALUES (?, ?, ?, ?, ?, ?, ?)'
    await db.insert(_tableName, cacheObj.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  @override
  Future<bool> removeObjectForKey(String key, {String? subKey}) async {
    var db = await dataBase;
    if (null == db) return false;
    String where = '$_column_urlPath="$key"';
    where += ' and $_column_subKey="$subKey"';
    return 0 != await db.delete(_tableName, where: where);
  }

  @override
  Future<bool> containsObjectForKey(String key, {String? subKey}) async {
    var db = await dataBase;
    if (null == db) return false;
    String where = '$_column_urlPath="$key"';
    where += ' and $_column_subKey="$subKey"';
    var list = await db.query(_tableName, where: where);
    if (list.isEmpty) return false;
    return true;
  }

  @override
  Future<bool> removeAllObjects() async {
    var db = await dataBase;
    if (null == db) return false;
    return 0 != await db.delete(_tableName);
  }

  @override
  Future<bool> clearExpiredObjects() async {
    var db = await dataBase;
    if (null == db) return false;
    return _clearExpiredObjects(db);
  }

  Future<bool> _clearExpiredObjects(Database? db) async {
    if (null == db) return false;
    var nowTime = DateTime.now().millisecondsSinceEpoch;
    String where = '$_column_endTime > 0 and $_column_endTime < $nowTime';
    return 0 != await db.delete(_tableName, where: where);
  }
}
