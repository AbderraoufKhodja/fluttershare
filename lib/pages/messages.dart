import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class Messages extends StatefulWidget {
  final String jobId;
  final String jobTitle;
  final String jobOwnerId;
  final String jobOwnerName;
  final String applicantId;
  final String applicantName;

  Messages({
    this.jobId,
    this.jobTitle,
    this.jobOwnerId,
    this.jobOwnerName,
    this.applicantId,
    this.applicantName,
  });

  @override
  MessagesState createState() => MessagesState(
        jobId: this.jobId,
        jobTitle: this.jobTitle,
        jobOwnerId: this.jobOwnerId,
        jobOwnerName: this.jobOwnerName,
        applicantId: this.applicantId,
        applicantName: this.applicantName,
      );
}

class MessagesState extends State<Messages> {
  TextEditingController messageController = TextEditingController();
  final String jobId;
  final String jobTitle;
  final String jobOwnerId;
  final String jobOwnerName;
  final String applicantId;
  final String applicantName;

  MessagesState({
    this.jobId,
    this.jobOwnerId,
    this.jobOwnerName,
    this.jobTitle,
    this.applicantId,
    this.applicantName,
  });

  buildMessages() {
    return StreamBuilder(
        stream: messagesRef
            .document(jobId)
            .collection('messages')
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Message> messages = [];
          snapshot.data.documents.forEach((doc) {
            messages.add(Message.fromDocument(doc));
          });
          return ListView(
            reverse: true,
            children: messages,
          );
        });
  }

  addMessage() {
    if (messageController.text.trim().isNotEmpty) {
      messagesRef.document(jobId).collection("messages").add({
        "userId": currentUser.id,
        "username": currentUser.username,
        "message": messageController.text,
        "avatarUrl": currentUser.photoUrl,
        "timestamp": FieldValue.serverTimestamp(),
      });
      String feedId = jobOwnerId;
      if (currentUser.id == jobOwnerId)
        feedId = applicantId;
      else if (currentUser.id == applicantId) feedId = jobOwnerId;
      activityFeedRef
          .document(feedId)
          .collection('feedItems')
          .document(jobId)
          .setData({
        "type": "message",
        "messageData": messageController.text,
        "jobId": jobId,
        "jobTitle": jobTitle,
        "applicantId": currentUser.id,
        "applicantName": currentUser.username,
        "userProfileImg": currentUser.photoUrl,
        "timestamp": FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "messages"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildMessages()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: messageController,
              decoration: InputDecoration(labelText: "Write a message..."),
            ),
            trailing: OutlineButton(
              onPressed: addMessage,
              borderSide: BorderSide.none,
              child: Text("send"),
            ),
          ),
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String message;
  final Timestamp timestamp;

  Message({
    this.username,
    this.userId,
    this.avatarUrl,
    this.message,
    this.timestamp,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      username: doc['username'],
      userId: doc['userId'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(message),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timestamp != null
              ? timeago.format(timestamp.toDate())
              : 'a moment ago'),
        ),
        Divider(),
      ],
    );
  }
}

showMessages(BuildContext context,
    {String jobId,
    String jobOwnerId,
    String jobOwnerName,
    String jobTitle,
    String applicantId,
    String applicantName}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Messages(
      jobId: jobId,
      jobOwnerId: jobOwnerId,
      jobTitle: jobTitle,
      applicantId: applicantId,
      applicantName: applicantName,
    );
  }));
}
