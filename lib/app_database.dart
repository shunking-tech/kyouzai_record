import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// テーブル名とカラム名は変数に入れておく方がいい
class AppDatabase {
  // データベースのコントローラーを取得する
  Future<Database> get database async {
    return await _initDB();
  }

  // データベースを作成・接続して、データベースのコントローラーを取得する
  Future<Database> _initDB() async {
    // データベースの保存場所
    String path = join(await getDatabasesPath(), 'database.db');

    return await openDatabase(
      path, // データベースの保存場所
      version: 1, // テーブル(表)の構造を変更する度に書き換えて+1増やす
      onCreate: (db, version) {
        // メモ情報を保存するためのテーブル(表)を作成
        return db.execute(
          '''
          CREATE TABLE memo(
            id INTEGER PRIMARY KEY,
            date TEXT,
            title TEXT,
            memo TEXT,
            slider REAL,
            drop_down_button TEXT,
            image_path TEXT
          )
          ''',
        );
      },
    );
  }
}