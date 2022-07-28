import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kouzai_record/app_database.dart';
import 'package:kouzai_record/logic/datetime_logic.dart';
import 'package:kouzai_record/memo.dart';
import 'package:path_provider/path_provider.dart';

class EditData extends StatefulWidget {
  final MemoModel? memoModel;
  const EditData({Key? key, this.memoModel}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  DateTime dateTime = DateTime.now();
  TextEditingController nameController = TextEditingController();
  TextEditingController memoEditingController = TextEditingController();
  String selectedCategory = "";
  File? saveFile;
  XFile? image;
  Uint8List? imageBytes;  // ImagePickerから選択した画像ファイルをこの形に変換する。端末内に保存する時に必要。
  String? saveFilePath; // 画像ファイルを保存するための、端末内のパスを保持する

  @override
  void initState() {
    super.initState();
    if (widget.memoModel != null) {
      print("更新");
      dateTime = DateTime.parse(widget.memoModel!.date.toString());
      nameController.text = widget.memoModel!.name!;
      memoEditingController.text = widget.memoModel!.memo!;
      selectedCategory = widget.memoModel!.category!;
      saveFilePath = widget.memoModel!.imagePath;
      if (saveFilePath != null) {
        saveFile = File(saveFilePath!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("編集画面"),
          actions: [
            if (widget.memoModel != null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("このメモを削除しますか？"),
                        actions: [
                          TextButton(
                            child: Text("キャンセル", style: TextStyle(color: Colors.grey),),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("削除する", style: TextStyle(color: Colors.red),),
                            onPressed: () async {
                              await AppDatabase().deleteMemo(widget.memoModel!.id!);
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                datePickerButton(),
                nameTextField(),
                memoTextField(),
                SizedBox(
                  height: 16.0,
                ),
                categoryDownButton(),
                imagePickerButton(),
                SizedBox(
                  height: 32.0,
                ),
                saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget datePickerButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: Text(DatetimeLogic.formatDate(dateTime)),
        onPressed: () async {
          DateTime? picked = await showDatePicker(
              context: context,
              locale: Locale("ja"),
              initialDate: dateTime,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(Duration(days: 365))
          );
          if(picked != null) {
            setState(() {
              dateTime = picked;
            });
          }
        },
      ),
    );
  }

  Widget nameTextField() {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: '名前',
      ),
    );
  }

  Widget memoTextField() {
    return TextField(
      controller: memoEditingController,
      maxLines: null,
      decoration: InputDecoration(
        labelText: 'メモ',
      ),
    );
  }

  Widget categoryDownButton() {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton(
        items: const [
          DropdownMenuItem(
            child: Text('-カテゴリを選択-'),
            value: '',
          ),
          DropdownMenuItem(
            child: Text('仕事'),
            value: '仕事',
          ),
          DropdownMenuItem(
            child: Text('趣味'),
            value: '趣味',
          ),
          DropdownMenuItem(
            child: Text('その他'),
            value: 'その他',
          ),
        ],
        onChanged: (String? value) {
          setState(() {
            selectedCategory = value!;
          });
        },
        value: selectedCategory,
      ),
    );
  }

  Widget imagePickerButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Icon(Icons.photo),
            label: Text("写真を選択"),
            onPressed: () async {
              ImagePicker picker = ImagePicker();
              XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) { // 写真を選択した場合、選択した写真ファイルをimageに代入
                image = pickedFile;
              }
              if (image != null) {
                saveFile = File(image!.path);
              }
              setState(() {});
            },
          ),
        ),
        if (saveFile != null)
          SizedBox(
            height: 200,
            child: Image.file(saveFile!),
          ),
      ],
    );
  }

  Widget saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.indigo),
        child: Text("保存"),
        onPressed: () async {
          print("日時");
          print(dateTime);
          print("タイトル");
          print(nameController.text);
          print("メモ");
          print(memoEditingController.text);
          print("ドロップダウンボタン");
          print(selectedCategory);

          if (image != null) {
            // 端末内の保存領域
            Directory applicationDirectory = await getApplicationDocumentsDirectory();
            saveFilePath = applicationDirectory.path + image!.name;  // 画像ファイルを保存するパス
            imageBytes = await image!.readAsBytes(); // 端末内に保存するために画像ファイルを変換する
            saveFile = File(saveFilePath!); // 保存先にファイルを作る
            saveFile = await saveFile!.writeAsBytes(imageBytes!); // 選択した画像ファイルを書き込む
          }
          print("写真");
          print(saveFile?.path);

          // 入力した値をmemoModelに持たせる
          MemoModel memoModel = MemoModel(
            id: widget.memoModel?.id,
            date: dateTime,
            name: nameController.text,
            memo: memoEditingController.text,
            category: selectedCategory,
            imagePath: saveFilePath,
          );
          if (widget.memoModel != null) { // 追加ボタンから編集画面を開いた時は、新規データを追加する
            await AppDatabase().updateMemo(memoModel);  // データを更新する
          } else {  // データ一覧から選択して編集画面を開いた時は、既存のデータを更新する
            await AppDatabase().insertMemo(memoModel);  // 入力した値をデータベースに追加する
          }

          Navigator.pop(context);
        },
      ),
    );
  }
}
