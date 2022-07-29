import 'package:flutter/material.dart';
import 'package:kouzai_record/app_database.dart';
import 'package:kouzai_record/logic/datetime_logic.dart';
import 'package:kouzai_record/person.dart';
import 'package:kouzai_record/page/edit_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchText,
          textInputAction: TextInputAction.search,
          onSubmitted: (text) {
            setState(() {});
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade200,
            prefixIcon: Icon(Icons.search, color: Colors.grey,),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchText.text = "";
                setState(() {});
              },
            ),
            hintText: "検索",
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: AppDatabase().getPersonList(searchText.text),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<PersonModel> personModelList = snapshot.data as List<PersonModel>;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(color: Colors.black, height: 1,);
              },
              itemCount: personModelList.length,
              itemBuilder: (context, index) {
                PersonModel personModelItem = personModelList[index];
                return ListTile(
                  title: Text(personModelItem.name!),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => EditData(personModel: personModelItem,)
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