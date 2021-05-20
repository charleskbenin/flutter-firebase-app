import 'dart:math';

import 'package:flutter/material.dart';

openDailog(
  BuildContext context,
  e,
) {
  var alert = AlertDialog(
    actions: [
      FlatButton(
          onPressed: () {
            
            Navigator.pop(context);
          },
          child: Text('OK')),
    ],
    title: Text("Wrong Input"),
    content: Text(e.toString()),
  );

  showDialog(
      context: context,
      builder: (context) {
        return alert;
      });
}
