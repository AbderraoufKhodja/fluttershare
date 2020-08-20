import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/pages/home.dart';

void main() {
  // TODO: fix timestamp bug
//  WidgetsFlutterBinding.ensureInitialized();
//  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
//    print("Timestamps enabled in snapshot\n");
//  }, onError: () {
//    print("Error in enabling timestamps in snapshot\n");
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
        accentColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
