import 'package:flutter/material.dart';

class EditData extends StatefulWidget {
  const EditData({Key? key}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController memoEditingController = TextEditingController();
  double sliderValue = 0.0;

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
          SizedBox(
            height: 16.0,
          ),
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
          ElevatedButton(
            child: Text("保存"),
            onPressed: () {
              print("タイトル");
              print(titleEditingController.text);
              print("メモ");
              print(memoEditingController.text);
              print("数値");
              print(sliderValue);
            },
          ),
        ],
      ),
    );
  }
}
