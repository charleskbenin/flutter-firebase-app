import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateData extends StatelessWidget {
  // const UpdateData({Key key}) : super(key: key);
  QuerySnapshot snapshots;
  int index;

  UpdateData({this.snapshots, this.index});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: snapshots.docs[index]["title"]);
    TextEditingController desController = TextEditingController(text: snapshots.docs[index]["description"]);
    ;

    return AlertDialog(
      content: Column(
        children: [
          Text("Update Todo"),
          TextField(
            controller: titleController,
            // decoration: InputDecoration(hintText: "Title here"),
          ),
          TextField(
            controller: desController,
            // decoration: InputDecoration(hintText: "Description here"),
          ),
          ElevatedButton(
            onPressed: () async{
              await FirebaseFirestore.instance
                  .runTransaction((Transaction myTransaction) async {
                myTransaction.update(snapshots.docs[index].reference,({
                  "title": titleController.text,
                  "description": desController.text
                }));
              });
              titleController.clear();
              desController.clear();
              Navigator.pop(context);
            },
            child: Text("Update Todo"),
          ),
        ],
      ),
    );
  }
}