import 'package:flutter/material.dart';
import 'package:kouzai_record/app_database.dart';
import 'package:kouzai_record/logic/datetime_logic.dart';
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
        title: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade200,
            prefixIcon: Icon(Icons.search, color: Colors.grey,),
            hintText: "検索",
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: AppDatabase().getMemos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<MemoModel> memoModelList = snapshot.data as List<MemoModel>;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(color: Colors.black, height: 1,);
              },
              itemCount: memoModelList.length,
              itemBuilder: (context, index) {
                MemoModel memoModelItem = memoModelList[index];
                return ListTile(
                  title: Text(memoModelItem.title!),
                  subtitle: Text(DatetimeLogic.formatDate(memoModelItem.date!)),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => EditData(memoModel: memoModelItem,)
                    ));
                    setState(() {});
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(
              builder: (context) => EditData()
          ));
          setState(() {});
        },
      ),
    );
  }
}