import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

  buildAuthScreen() {
    return Scaffold(Container(
      child: Column(
        children: <Widget>[
          Text(),
        ],
      ),
    ));
  }

  buildUnAuthScreen() {
    return Text('Authenticated');
  }
}
