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
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15.0),
              padding: EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: Colors.grey.withOpacity(0.5),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "$label ",
                        style: kTextStyleProfileInfoHeader,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                      color: Colors.white,
                    ),
                    child: Text(
                      "$text",
                      style: kTextStyleProfileInfo,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
