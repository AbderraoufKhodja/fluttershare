import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:khadamat/pages/home.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context),
      body: StreamBuilder<QuerySnapshot>(
          stream: usersRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return circularProgress();
            final List<Text> children = snapshot.data.documents
                .map((doc) => Text(doc['username']))
                .toList();
            return ListView(
              children: children,
            );
          }),
    );
  }

  void createUser() {
    usersRef.document("asdfasdfd").setData({
      "username": "Jeff",
      "postCount": 0,
      "isAdmin": false,
    });
  }

  void deleteUser() async {
    final doc = await usersRef.document("asdfasdfd").get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  void updateUser() async {
    final doc = await usersRef.document("asdfasdfd").get();
    if (doc.exists) {
      doc.reference.updateData({
        "username": "Jeff",
        "postCount": 0,
        "isAdmin": false,
      });
    }
  }

  // void getUsers() async {
  //   QuerySnapshot usersData =
  //       await userRef.where("username", isEqualTo: 'Bernard').getDocuments();
  //   for (DocumentSnapshot doc in usersData.documents) {
  //     print(doc.data);
  //     print(doc.documentID);
  //     print(doc.exists);
  //   }
  // }
}
