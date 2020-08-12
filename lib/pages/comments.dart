import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  Comments({this.postId, this.postOwnerId, this.postMediaUrl});

  @override
  CommentsState createState() => CommentsState(
      postId: this.postId,
      postMediaUrl: this.postOwnerId,
      postOwnerId: this.postMediaUrl);
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  CommentsState({this.postId, this.postOwnerId, this.postMediaUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        isAppTitle: false,
        titleText: "Comments",
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComment()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Write a comment",
              ),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("post"),
            ),
          )
        ],
      ),
    );
  }

  buildComment() {
    return StreamBuilder<QuerySnapshot>(
        stream: commentsRef
            .document(postId)
            .collection('comments')
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return circularProgress();
          final List<Comment> comments = [];
          snapshot.data.documents.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: comments,
          );
        });
  }

  addComment() {
    //TODO: has a bug on the timestamp
    commentsRef.document(postId).collection('comments').add({
      "userName": currentUser.userName,
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser.photoUrl,
      "userId": currentUser.id,
    });
    commentController.clear();
  }
}

class Comment extends StatelessWidget {
  final String userName;
  final String userId;
  final String comment;
  final String avatarUrl;
  final Timestamp timestamp;

  Comment(
      {this.userName,
      this.userId,
      this.comment,
      this.avatarUrl,
      this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          title: Text(comment),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      userName: doc["userName"],
      comment: doc["comment"],
      avatarUrl: doc["avatarUrl"],
      timestamp: doc["timestamp"],
    );
  }
}
