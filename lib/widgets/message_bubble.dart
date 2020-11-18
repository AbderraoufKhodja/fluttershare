import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key key,
    @required this.isCurrentUser,
    @required this.message,
    @required this.createdAt,
  }) : super(key: key);

  final bool isCurrentUser;
  final String message;
  final Timestamp createdAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Bubble(
          margin: BubbleEdges.only(top: 10),
          alignment: isCurrentUser == null
              ? Alignment.center
              : isCurrentUser ? Alignment.topRight : Alignment.topLeft,
          nip: isCurrentUser == null
              ? BubbleNip.no
              : isCurrentUser ? BubbleNip.rightTop : BubbleNip.leftTop,
          color: isCurrentUser == null
              ? Colors.blue
              : isCurrentUser
                  ? Color.fromRGBO(225, 255, 199, 1.0)
                  : Colors.white,
          child: Text(message),
        ),
        Container(
          padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 3.0),
          child: Text(
            createdAt != null
                ? timeago.format(createdAt.toDate())
                : 'a moment ago',
            style: TextStyle(color: Colors.grey, fontSize: 11.0),
            textAlign: isCurrentUser == null
                ? TextAlign.center
                : isCurrentUser ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}
