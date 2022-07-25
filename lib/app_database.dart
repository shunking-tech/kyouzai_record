import 'package:kouzai_record/memo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<void> insertMemo(MemoModel memoModel) async {
    final Database db = await database;
    await db.insert(
      "memo",
      memoModel.toMap(),
    );
  }

  Future<List<MemoModel>> getMemos(String keyword) async {
    final Database db = await database;
    List<Map<String, dynamic>> memoMapList;
    if (keyword.isEmpty) {
      memoMapList = await db.query('memo', orderBy: "date DESC");
    } else {
      memoMapList = await db.query(
        'memo',
        orderBy: "date DESC",
        where: "title LIKE ? OR memo LIKE ?",
        whereArgs: ["%$keyword%", "%$keyword%"]
      );
    }
    return List.generate(memoMapList.length, (i) {
      return MemoModel(
        id: memoMapList[i]['id'],
        date: DateTime.parse(memoMapList[i]['date']),
        title: memoMapList[i]['title'],
        memo: memoMapList[i]['memo'],
        slider: memoMapList[i]['slider'],
        dropDownButton: memoMapList[i]['drop_down_button'],
        imagePath: memoMapList[i]['image_path'],
      );
    });
  }

  Future<void> updateMemo(MemoModel memoModel) async {
    final Database db = await database;
    await db.update(
      "memo",
      memoModel.toMap(),
      where: "id = ?",
      whereArgs: [memoModel.id],
    );
  }

  Future<void> deleteMemo(int id) async {
    final Database db = await database;
    await db.delete(
      "memo",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}