// import 'package:database_demo/Dats_Entry.dart';
import 'package:database_demo/add_user.dart';
import 'package:database_demo/database/my_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class User_list extends StatefulWidget {
  @override
  State<User_list> createState() => _User_listState();
}

class _User_listState extends State<User_list> {
  var db = MyDatabase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('list')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.white70,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return adduser(null);
                // return EnterDetail(Detail: null,);
              },
            ),
          ).then((value){
            if(value==true){
              setState(() {

              });
            }
          } );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: FutureBuilder(
        future: db.copyPasteAssetFileToRoot(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
                future: db.getDetails(),
                builder: (context, snapshotList) {
                  if (snapshotList.hasData ) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(child: Text(snapshotList.data![index]['name'].toString())),
                                Container(
                                  child: IconButton(onPressed: () async {
                                    await MyDatabase().deleteUser(snapshotList.data![index]["id"]).then((value) {setState(() {});});

                                  }, icon: Icon(Icons.delete)),
                                ),
                                Container(
                                  child: TextButton(
                                    child: Icon(Icons.edit),
                                    onPressed: () async {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        return adduser(snapshotList.data![index]);
                                      },)).then((value) {
                                        setState(() {

                                        });
                                      });

                                    },
                                  ),
                                )

                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snapshotList.data!.length,
                    );
                  }
                  else {
                    return CircularProgressIndicator();
                  }
                });
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
