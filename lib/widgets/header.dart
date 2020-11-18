import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false,
    String titleText,
    bool implyBackButton = false,
    bool hasAction = true,
    Map<String, Function> actionsList}) {
  return AppBar(
    actions: [
      hasAction
          ? PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => actionsList.keys
                  .map(
                    (action) => PopupMenuItem<String>(
                      value: action,
                      child: Text(
                        action,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onSelected: (label) => actionsList[label],
              icon: Icon(Icons.more_vert),
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
    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(
    //     bottom: Radius.circular(90),
    //   ),
    // ),
  );
}
