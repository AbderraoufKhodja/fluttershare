import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';

class CustomField extends StatelessWidget {
  final String label;
  final String text;

  const CustomField({
    this.label,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$label ",
                style: kTextStyleProfileInfoHeader,
              ),
              Expanded(
                child: Text(
                  "$text",
                  style: kTextStyleProfileInfo,
                ),
              ),
            ],
          ),
        ),
        Divider(height: 0.0, indent: 30.0, endIndent: 30.0),
      ],
    );
  }
}
