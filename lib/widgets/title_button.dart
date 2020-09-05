import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/pages/main_jobs_screen.dart';

class TitleButton extends StatelessWidget {
  final String professionalTitle;
  TitleButton({this.professionalTitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMainJobsScreen(context, title: professionalTitle);
      },
      child: Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "$professionalTitle",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
