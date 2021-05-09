import 'package:flutter/material.dart';

class MyForumSubscribtionsPage extends StatefulWidget {
  MyForumSubscribtionsPage({Key key}) : super(key: key);

  @override
  _MyForumSubscribtionsPageState createState() =>
      _MyForumSubscribtionsPageState();
}

class _MyForumSubscribtionsPageState extends State<MyForumSubscribtionsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          "Posts",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
