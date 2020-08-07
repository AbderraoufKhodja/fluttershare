import 'package:flutter/material.dart';

header(context,
    {bool isAppTitle: true, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? 'Khadamat' : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? 'Signatra' : '',
        fontSize: isAppTitle ? 50.0 : 20.0,
      ),
    ),
    centerTitle: true,
  );
}