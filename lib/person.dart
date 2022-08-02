import 'package:kouzai_record/app_database.dart';
import 'package:sqflite/sqflite.dart';

class PersonModel {
  final int? id;
  final String? name;
  final String? affiliation;
  final String? memo;
  final String? category;
  final String? imagePath;
  final String? createdAt;

  PersonModel({this.id, this.name, this.affiliation, this.memo, this.category, this.imagePath, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      personId: id,
      personName: name,
      personAffiliation: affiliation,
      personMemo: memo,
      personCategory: category,
      personImagePath: imagePath,
      personCreatedAt: createdAt,
    };
  }
}