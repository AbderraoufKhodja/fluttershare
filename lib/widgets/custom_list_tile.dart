import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    @required this.description,
    @required this.icon,
    this.maxLines = 1,
  });

  final Icon icon;
  final String description;
  final maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.only(bottom: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
      child: Row(
        children: [
          icon,
          Text(" | "),
          Flexible(
            child: Text(
              description,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  }
}
