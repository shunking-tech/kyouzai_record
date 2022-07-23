import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kouzai_record/app_database.dart';
import 'package:kouzai_record/memo.dart';
import 'package:path_provider/path_provider.dart';

class EditData extends StatefulWidget {
  const EditData({Key? key}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  DateTime dateTime = DateTime.now();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController memoEditingController = TextEditingController();
  double sliderValue = 0.0;
  String selectedItem = "選択肢1";
  File? saveFile;
  XFile? image;
  Uint8List? imageBytes;  // ImagePickerから選択した画像ファイルをこの形に変換する。端末内に保存する時に必要。
  String? saveFilePath; // 画像ファイルを保存するための、端末内のパスを保持する

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("編集画面"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              datePickerButton(),
              titleTextField(),
              memoTextField(),
              SizedBox(
                height: 16.0,
              ),
              slider(),
              dropDownButton(),
              imagePickerButton(),
              SizedBox(
                height: 32.0,
              ),
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate() {
    DateFormat format = DateFormat('yyyy年MM月dd日');
    String dateText = format.format(dateTime);
    return dateText;
  }

  Widget datePickerButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: Text(formatDate()),
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

  Widget titleTextField() {
    return TextField(
      controller: titleEditingController,
      decoration: InputDecoration(
        labelText: 'タイトル',
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

  Widget slider() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "数値",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Slider(
          label: sliderValue.toInt().toString(),
          min: 0,
          max: 100,
          value: sliderValue,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
          divisions: 20,
          onChanged: (value) {
            setState(() {
              sliderValue = value;
            });
          },
        ),
        Text(
          sliderValue.toInt().toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget dropDownButton() {
    return SizedBox(
      width: double.infinity,
      child: DropdownButton(
        items: const [
          DropdownMenuItem(
            child: Text('選択肢1'),
            value: '選択肢1',
          ),
          DropdownMenuItem(
            child: Text('選択肢2'),
            value: '選択肢2',
          ),
          DropdownMenuItem(
            child: Text('選択肢3'),
            value: '選択肢3',
          ),
        ],
        onChanged: (String? value) {
          setState(() {
            selectedItem = value!;
          });
        },
        value: selectedItem,
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
          print(titleEditingController.text);
          print("メモ");
          print(memoEditingController.text);
          print("数値");
          print(sliderValue);
          print("ドロップダウンボタン");
          print(selectedItem);

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
            date: dateTime,
            title: titleEditingController.text,
            memo: memoEditingController.text,
            slider: sliderValue,
            dropDownButton: selectedItem,
            imagePath: saveFilePath,
          );
          await AppDatabase().insertMemo(memoModel);  // 入力した値をデータベースに追加する

          Navigator.pop(context);
        },
      ),
    );
  }
}
