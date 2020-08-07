import 'package:flutter/material.dart';
import 'package:khadamat/widgets/header.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, titleText: 'Profile'),
      body: Text('profile'),
    );
  }
}