import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/pages/professional_titles_screen.dart';

class JobCategoryTile extends StatelessWidget {
  final String professionalCategory;
  JobCategoryTile({this.professionalCategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showProfessionalTitlesScreen(context, category: professionalCategory);
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
              "$professionalCategory",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
