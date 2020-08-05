import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

final userRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    // createUser();
    deleteUser();
    // updateUser();
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context),
      body: StreamBuilder<QuerySnapshot>(
          stream: userRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return circularProgress();
            final List<Text> children = snapshot.data.documents
                .map((doc) => Text(doc['userName']))
                .toList();
            return ListView(
              children: children,
            );
          }),
    );
  }

  void createUser() {
    userRef.document("asdfasdfd").setData({
      "userName": "Jeff",
      "postCount": 0,
      "isAdmin": false,
    });
  }

  void deleteUser() async {
    final doc = await userRef.document("asdfasdfd").get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  void updateUser() async {
    final doc = await userRef.document("asdfasdfd").get();
    if (doc.exists) {
      doc.reference.updateData({
        "userName": "Jeff",
        "postCount": 0,
        "isAdmin": false,
      });
    }
  }

  // void getUsers() async {
  //   QuerySnapshot usersData =
  //       await userRef.where("userName", isEqualTo: 'Bernard').getDocuments();
  //   for (DocumentSnapshot doc in usersData.documents) {
  //     print(doc.data);
  //     print(doc.documentID);
  //     print(doc.exists);
  //   }
  // }
}
