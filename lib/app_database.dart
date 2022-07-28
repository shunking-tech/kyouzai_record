import 'package:kouzai_record/memo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String memoTableName = "memo";
const String memoId = "id";
const String memoDate = "date";
const String memoOpponentName = "opponentName";
const String memoMemo = "memo";
const String memoSlider = "slider";
const String memoDropDownButton = "drop_down_button";
const String memoImagePath = "image_path";

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
        print("データベース作成");
        // メモ情報を保存するためのテーブル(表)を作成
        return db.execute(
          '''
          CREATE TABLE $memoTableName(
            $memoId INTEGER PRIMARY KEY,
            $memoDate TEXT,
            $memoOpponentName TEXT,
            $memoMemo TEXT,
            $memoSlider REAL,
            $memoDropDownButton TEXT,
            $memoImagePath TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertMemo(MemoModel memoModel) async {
    final Database db = await database;
    await db.insert(
      memoTableName,
      memoModel.toMap(),
    );
  }

  Future<List<MemoModel>> getMemos(String keyword) async {
    final Database db = await database;
    List<Map<String, dynamic>> memoMapList;
    if (keyword.isEmpty) {
      memoMapList = await db.query(memoTableName, orderBy: "$memoDate DESC");
    } else {
      memoMapList = await db.query(
        memoTableName,
        orderBy: "$memoId DESC",
        where: "$memoOpponentName LIKE ? OR $memoMemo LIKE ?",
        whereArgs: ["%$keyword%", "%$keyword%"]
      );
    }
    return List.generate(memoMapList.length, (i) {
      return MemoModel(
        id: memoMapList[i][memoId],
        date: DateTime.parse(memoMapList[i][memoDate]),
        opponentName: memoMapList[i][memoOpponentName],
        memo: memoMapList[i][memoMemo],
        slider: memoMapList[i][memoSlider],
        dropDownButton: memoMapList[i][memoDropDownButton],
        imagePath: memoMapList[i][memoImagePath],
      );
    });
  }

  Future<void> updateMemo(MemoModel memoModel) async {
    final Database db = await database;
    await db.update(
      memoTableName,
      memoModel.toMap(),
      where: "$memoId = ?",
      whereArgs: [memoModel.id],
    );
  }

  Future<void> deleteMemo(int id) async {
    final Database db = await database;
    await db.delete(
      memoTableName,
      where: "$memoId = ?",
      whereArgs: [id],
    );
  }
}