import 'package:flutter/material.dart';

header(context,
    {bool isAppTitle: true,
    String titleText,
    bool removeBackButton = false,
    bool hasAction = false,
    Function action}) {
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
    actions: <Widget>[
      hasAction
          ? IconButton(
              onPressed: action,
              icon: Icon(
                Icons.clear,
                size: 30.0,
                color: Colors.grey,
              ),
            )
          : Text(""),
    ],
    centerTitle: true,
  );
}
