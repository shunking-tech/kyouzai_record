import 'package:flutter/material.dart';

class EditData extends StatefulWidget {
  const EditData({Key? key}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController memoEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("編集画面"),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleEditingController,
            decoration: InputDecoration(
              labelText: 'タイトル',
            ),
          ),
          TextField(
            controller: memoEditingController,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'メモ',
            ),
          ),
          ElevatedButton(
            child: Text("保存"),
            onPressed: () {
              print("タイトル");
              print(titleEditingController.text);
              print("メモ");
              print(memoEditingController.text);
            },
          ),
        ],
      ),
    );
  }
}
