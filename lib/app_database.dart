import 'package:kouzai_record/person.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String personTableName = "person";
const String personId = "id";
const String personName = "name";
const String personAffiliation = "affiliation";
const String personMemo = "memo";
const String personCategory = "category";
const String personImagePath = "image_path";

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
          CREATE TABLE $personTableName(
            $personId INTEGER PRIMARY KEY,
            $personName TEXT,
            $personAffiliation TEXT,
            $personMemo TEXT,
            $personCategory TEXT,
            $personImagePath TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertPerson(PersonModel personModel) async {
    final Database db = await database;
    await db.insert(
      personTableName,
      personModel.toMap(),
    );
  }

  Future<List<PersonModel>> getPersonList(String keyword) async {
    final Database db = await database;
    List<Map<String, dynamic>> personMapList;
    if (keyword.isEmpty) {
      personMapList = await db.query(personTableName, orderBy: "$personId DESC");
    } else {
      personMapList = await db.query(
        personTableName,
        orderBy: "$personId DESC",
        where: "$personName LIKE ? OR $personMemo LIKE ? OR $personAffiliation LIKE ?",
        whereArgs: ["%$keyword%", "%$keyword%", "%$keyword%"]
      );
    }
    return List.generate(personMapList.length, (i) {
      return PersonModel(
        id: personMapList[i][personId],
        name: personMapList[i][personName],
        affiliation: personMapList[i][personAffiliation],
        memo: personMapList[i][personMemo],
        category: personMapList[i][personCategory],
        imagePath: personMapList[i][personImagePath],
      );
    });
  }

  Future<void> updatePerson(PersonModel personModel) async {
    final Database db = await database;
    await db.update(
      personTableName,
      personModel.toMap(),
      where: "$personId = ?",
      whereArgs: [personModel.id],
    );
  }

  Future<void> deletePerson(int id) async {
    final Database db = await database;
    await db.delete(
      personTableName,
      where: "$personId = ?",
      whereArgs: [id],
    );
  }
}