import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false,
    String titleText,
    implyBackButton = false,
    hasAction = false,
    Function action,
    actionLabel = "press"}) {
  return AppBar(
    actions: [
      hasAction
          ? PopupMenuButton<Widget>(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<Widget>(
                  value: actionLabel,
                  child: Text(
                    actionLabel,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                PopupMenuItem<Widget>(
                  value: actionLabel,
                  child: Text(
                    actionLabel,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                )
              ],
              icon: Icon(Icons.more_vert),
              onSelected: (value) {},
              
            )
          : Container()
    ],
    automaticallyImplyLeading: implyBackButton,
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
    centerTitle: false,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(90),
      ),
    ),
  );
}
