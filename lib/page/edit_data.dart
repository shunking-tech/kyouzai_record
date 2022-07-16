import 'package:flutter/material.dart';

class EditData extends StatefulWidget {
  const EditData({Key? key}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("編集画面"),
      ),
      body: Column(
        children: [
          TextField(
            controller: textEditingController,
          ),
          ElevatedButton(
            child: Text("保存"),
            onPressed: () {
              print(textEditingController.text);
            },
          ),
        ],
      ),
    );
  }
}
