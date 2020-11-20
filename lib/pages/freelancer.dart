import 'package:flutter/material.dart';

class Freelancer extends StatefulWidget {
  @override
  _Freelancer createState() => _Freelancer();
}

class _Freelancer extends State<Freelancer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(),
      ),
    );
  }
}
