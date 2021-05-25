import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/screens/register.dart';
import 'package:firebase_app/screens/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'register.dart';
import '../update_data.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final User user = auth.currentUser;







class MyHomePage extends StatefulWidget {
  String userID;
  MyHomePage({this.userID});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController;
  TextEditingController desController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    desController = TextEditingController();
    var id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Text(userEmail),
          IconButton(
            icon: Icon(Icons.logout), 
            onPressed: (){
              auth.signOut();
              Navigator.push(context,
              MaterialPageRoute(
                builder: (_)=> SignInPage()
              )
              );
            }
          )
        ],
        centerTitle: true,
        title: Text('Firebase Todo'),
        automaticallyImplyLeading: false
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: firebaseFirestore.collection(widget.userID).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (snapshots.hasData) {
              return snapshots.data.docs.isEmpty ?
              Center(
                child: Text("No todo..."),
              ) :
              ListView.builder(
                  reverse: true,
                  itemCount: snapshots.data.docs.length,
                  itemBuilder: (context, index) {
                    var getData = snapshots.data.docs[index];
                    var dateTime = DateTime.fromMillisecondsSinceEpoch(
                        snapshots.data.docs[index]["timestamp"]);
                    var formatDate =
                        DateFormat("kk:mm-dd").format(dateTime).toString();
                    return Card(
                      elevation: 50,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(getData["title"]),
                            subtitle: Text(getData["description"]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: CircleAvatar(
                                        child: Icon(Icons.edit),
                                        backgroundColor: Colors.black87,
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (contex) => UpdateData(
                                                index: index,
                                                snapshots: snapshots.data));
                                      },
                                    ),
                                    IconButton(
                                      icon: CircleAvatar(
                                        child: Icon(Icons.delete),
                                        backgroundColor: Colors.black87,
                                      ),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .runTransaction((Transaction
                                                myTransaction) async {
                                          myTransaction.delete(snapshots
                                              .data.docs[index].reference);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Text(formatDate.toString() == null
                                  ? ""
                                  : formatDate.toString())
                            ],
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        onPressed: () {
          addData(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  addData(BuildContext context,
      {QueryDocumentSnapshot snapshot, Timestamp timestamp}) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                children: [
                  Text("Add Task"),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "Title here"),
                  ),
                  TextField(
                    controller: desController,
                    decoration: InputDecoration(hintText: "Description here"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      firebaseFirestore.collection(widget.userID).add({
                        "title": titleController.text,
                        "description": desController.text,
                        "timestamp": Timestamp.now().millisecondsSinceEpoch
                      });
                      titleController.clear();
                      desController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Add Todo"),
                  ),
                ],
              ),
            ));
  }
}
