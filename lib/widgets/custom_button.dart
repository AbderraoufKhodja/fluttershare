import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function function;

  CustomButton({
    @required this.text,
    @required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: function,
      child: Container(
        width: MediaQuery.of(context).size.width * (1 / 3),
        height: MediaQuery.of(context).size.height * (1 / 18),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
