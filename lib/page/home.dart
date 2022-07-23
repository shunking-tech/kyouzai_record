import 'package:flutter/material.dart';
import 'package:kouzai_record/app_database.dart';
import 'package:kouzai_record/memo.dart';
import 'package:kouzai_record/page/edit_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: FutureBuilder(
        future: AppDatabase().getMemos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<MemoModel> memoModelList = snapshot.data as List<MemoModel>;
            return ListView.builder(
              itemCount: memoModelList.length,
              itemBuilder: (context, index) {
                MemoModel memoModelItem = memoModelList[index];
                return ListTile(
                  title: Text(memoModelItem.title!),
                  subtitle: Text(memoModelItem.date.toString()),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => EditData()
          ));
        },
      ),
    );
  }
}