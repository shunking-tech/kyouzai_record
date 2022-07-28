import 'package:kouzai_record/app_database.dart';
import 'package:sqflite/sqflite.dart';

class MemoModel {
  final int? id;
  final DateTime? date;
  final String? name;
  final String? memo;
  final String? category;
  final String? imagePath;

  MemoModel({this.id, this.date, this.name, this.memo, this.category, this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      memoId: id,
      memoDate: date.toString(),
      memoName: name,
      memoMemo: memo,
      memoCategory: category,
      memoImagePath: imagePath,
    };
  }
}