import 'package:kouzai_record/app_database.dart';
import 'package:sqflite/sqflite.dart';

class MemoModel {
  final int? id;
  final String? name;
  final String? affiliation;
  final String? memo;
  final String? category;
  final String? imagePath;

  MemoModel({this.id, this.name, this.affiliation, this.memo, this.category, this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      memoId: id,
      memoName: name,
      memoAffiliation: affiliation,
      memoMemo: memo,
      memoCategory: category,
      memoImagePath: imagePath,
    };
  }
}