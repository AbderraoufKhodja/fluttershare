import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function function;
  final Color fillColor;
  final double padding;
  final double heightFactor;
  final double widthFactor;

  CustomButton({
    @required this.text,
    @required this.function,
    this.fillColor,
    this.padding = 0,
    this.heightFactor = 1,
    this.widthFactor = 1,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: function,
      child: Container(
        padding: EdgeInsets.all(padding),
        width: MediaQuery.of(context).size.width * (1 / 3) * widthFactor,
        height: MediaQuery.of(context).size.height * (1 / 18) * heightFactor,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fillColor,
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
