import 'package:kouzai_record/app_database.dart';
import 'package:sqflite/sqflite.dart';

class MemoModel {
  final int? id;
  final DateTime? date;
  final String? opponentName;
  final String? memo;
  final double? slider;
  final String? dropDownButton;
  final String? imagePath;

  MemoModel({this.id, this.date, this.opponentName, this.memo, this.slider, this.dropDownButton, this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      memoId: id,
      memoDate: date.toString(),
      memoOpponentName: opponentName,
      memoMemo: memo,
      memoSlider: slider,
      memoDropDownButton: dropDownButton,
      memoImagePath: imagePath,
    };
  }
}