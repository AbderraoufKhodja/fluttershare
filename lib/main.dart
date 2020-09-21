import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/pages/home.dart';

void main() {
  // TODO: fix createdAt bug
//  WidgetsFlutterBinding.ensureInitialized();
//  Firestore.instance.settings(createdAtsInSnapshotsEnabled: true).then((_) {
//    print("Timestamps enabled in snapshot\n");
//  }, onError: () {
//    print("Error in enabling createdAts in snapshot\n");
//  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khadamat',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        accentColor: Colors.black,
        backgroundColor: Colors.white70,
        scaffoldBackgroundColor: Colors.white.withOpacity(0.97),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
