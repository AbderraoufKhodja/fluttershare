import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false,
    String titleText,
    removeBackButton = false,
    hasAction = false,
    Function action,
    actionLabel = "press"}) {
  return AppBar(
    actions: [
      hasAction
          ? FlatButton(
              onPressed: action,
              child: Text(
                actionLabel,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            )
          : Text("")
    ],
    automaticallyImplyLeading: removeBackButton ? false : true,
    elevation: 0,
    title: Text(
      isAppTitle ? "المهَنــي" : titleText,
      style: TextStyle(
        color: Colors.black,
        fontFamily: isAppTitle ? "ReemKufi-Regular" : "",
        fontSize: isAppTitle ? 40.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(90),
      ),
    ),
  );
}
