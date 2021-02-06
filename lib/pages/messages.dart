import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/message_bubble.dart';
import 'package:khadamat/widgets/progress.dart';

class Messages extends StatefulWidget {
  final String jobChatId;
  final String jobId;
  final String professionalTitle;
  final String jobTitle;
  final String jobOwnerId;
  final String jobOwnerName;

  Messages({
    @required this.jobChatId,
    @required this.jobId,
    @required this.professionalTitle,
    @required this.jobTitle,
    @required this.jobOwnerId,
    @required this.jobOwnerName,
  });

  @override
  MessagesState createState() => MessagesState(
        jobChatId: this.jobChatId,
        jobId: this.jobId,
        professionalTitle: this.professionalTitle,
        jobTitle: this.jobTitle,
        jobOwnerId: this.jobOwnerId,
        jobOwnerName: this.jobOwnerName,
      );
}

class MessagesState extends State<Messages> {
  TextEditingController messageController = TextEditingController();
  final String jobChatId;
  final String jobId;
  final String professionalTitle;
  final String jobTitle;
  final String jobOwnerId;
  final String jobOwnerName;
  final String jobFreelancerId;
  final String jobFreelancerName;
  bool isJobOwner = false;

  MessagesState({
    this.jobChatId,
    this.jobId,
    this.professionalTitle,
    this.jobTitle,
    this.jobOwnerId,
    this.jobOwnerName,
    this.jobFreelancerId,
    this.jobFreelancerName,
  });
  @override
  void initState() {
    super.initState();
    checkIfJobOwner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Expanded(child: buildMessages()),
            Divider(),
            buildTextField(),
          ],
        ),
      ),
    );
  }

  ListTile buildTextField() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: TextFormField(
        controller: messageController,
        decoration: InputDecoration(labelText: "Write a message..."),
      ),
      trailing: OutlineButton(
        onPressed: () async {
          // TODO add spinner
          addMessage(type: "message");
        },
        borderSide: BorderSide.none,
        child: Icon(
          Icons.send,
          size: 40,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return header(
      context,
      titleText: "messages",
    );
  }

  checkIfJobOwner() {
    setState(() {
      isJobOwner = currentUser.uid == jobOwnerId;
    });
  }

  buildMessages() {
    return StreamBuilder(
        stream: messagesRef
            .doc(jobId)
            .collection(jobChatId)
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Message> messages = [];
          snapshot.data.docs.forEach((doc) {
            messages.add(Message.fromDocument(doc));
          });
          return ListView(
            reverse: true,
            children: messages,
          );
        });
  }

  Future<void> addMessage({@required String type}) async {
    if (messageController.text.trim().isNotEmpty) {
      messagesRef.doc(jobId).collection(jobChatId).add({
        "type": type,
        "userId": currentUser.uid,
        "username": currentUser.username,
        "message": messageController.text,
        "avatarUrl": currentUser.photoURL,
        "createdAt": FieldValue.serverTimestamp(),
      });
      String feedId = jobOwnerId;
      if (currentUser.uid == jobOwnerId)
        feedId = jobFreelancerId;
      else if (currentUser.uid == jobFreelancerId) feedId = jobOwnerId;
      print(feedId);
      activityFeedRef
          .doc(feedId)
          .collection('feedItems')
          .doc(currentUser.uid + jobId)
          .set({
        "type": "message",
        "messageText": messageController.text,
        "jobId": jobId,
        "jobChatId": jobChatId,
        "professionalTitle": professionalTitle,
        "jobTitle": jobTitle,
        "jobOwnerName": jobOwnerName,
        "jobOwnerId": jobOwnerId,
        "jobFreelancerId": currentUser.uid,
        "jobFreelancerName": currentUser.username,
        "userProfileImg": currentUser.photoURL ?? kBlankProfileUrl,
        "read": false,
        "createdAt": FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }

  // showConfirmDialog(BuildContext parentContext) {
  //   return showDialog(
  //       context: parentContext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Text(kUpdateConfirmCancel),
  //           children: <Widget>[
  //             SimpleDialogOption(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   confirmAcceptance();
  //                 },
  //                 child: Text(
  //                   kUpdateJobTerms,
  //                   style: TextStyle(color: Colors.green),
  //                 )),
  //             SimpleDialogOption(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   cancelAcceptance();
  //                 },
  //                 child: Text(
  //                   kCancelAcceptance,
  //                   style: TextStyle(color: Colors.red),
  //                 )),
  //             SimpleDialogOption(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text('Cancel')),
  //           ],
  //         );
  //       });
  // }

  confirmAcceptance() {
    showManageJob(context, jobId: jobId);
    Navigator.pop(context);
  }

  cancelAcceptance() {
    showManageJob(
      context,
      jobId: jobId,
    );
    Navigator.pop(context);
  }
}

class Message extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String type;
  final String message;
  final Timestamp createdAt;

  Message({
    this.type,
    this.username,
    this.userId,
    this.avatarUrl,
    this.message,
    this.createdAt,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      message: doc['message'],
      avatarUrl: doc['avatarUrl'],
      createdAt: doc['createdAt'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = currentUser.uid == userId;
    return type == "open"
        ? MessageBubble(
            isCurrentUser: null, message: kOpenChat, createdAt: createdAt)
        : MessageBubble(
            isCurrentUser: isCurrentUser,
            message: message,
            createdAt: createdAt);
  }
}

showMessages(
  BuildContext context, {
  @required String jobChatId,
  @required String jobId,
  @required String professionalTitle,
  @required String jobTitle,
  @required String jobOwnerId,
  @required String jobOwnerName,
}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Messages(
      jobChatId: jobChatId,
      jobId: jobId,
      professionalTitle: professionalTitle,
      jobTitle: jobTitle,
      jobOwnerId: jobOwnerId,
      jobOwnerName: jobOwnerName,
    );
  }));
}
