import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    @required this.description,
    this.icon,
  });

  final Icon icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.only(bottom: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Row(
        children: [
          icon,
          Text(" | "),
          Flexible(
            child: Text(
              description,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
