import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

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
          addMessage();
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
      isJobOwner = currentUser.id == jobOwnerId;
    });
  }

  buildMessages() {
    return StreamBuilder(
        stream: messagesRef
            .document(jobId)
            .collection(jobChatId)
            .orderBy("createdAt", descending: true)
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

  Future<void> addMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      messagesRef.document(jobId).collection(jobChatId).add({
        "userId": currentUser.id,
        "username": currentUser.username,
        "message": messageController.text,
        "avatarUrl": currentUser.photoUrl,
        "createdAt": FieldValue.serverTimestamp(),
      });
      String feedId = jobOwnerId;
      if (currentUser.id == jobOwnerId)
        feedId = jobFreelancerId;
      else if (currentUser.id == jobFreelancerId) feedId = jobOwnerId;
      print(feedId);
      activityFeedRef
          .document(feedId)
          .collection('feedItems')
          .document(currentUser.id + jobId)
          .setData({
        "type": "message",
        "messageText": messageController.text,
        "jobId": jobId,
        "jobChatId": jobChatId,
        "professionalTitle": professionalTitle,
        "jobTitle": jobTitle,
        "jobOwnerName": jobOwnerName,
        "jobOwnerId": jobOwnerId,
        "jobFreelancerId": currentUser.id,
        "jobFreelancerName": currentUser.username,
        "userProfileImg": currentUser.photoUrl ?? kBlankProfileUrl,
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
  final String message;
  final Timestamp createdAt;

  Message({
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
      message: doc['message'],
      avatarUrl: doc['avatarUrl'],
      createdAt: doc['createdAt'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = currentUser.id == userId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Bubble(
          margin: BubbleEdges.only(top: 10),
          alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
          nip: isCurrentUser ? BubbleNip.rightTop : BubbleNip.leftTop,
          color:
              isCurrentUser ? Color.fromRGBO(225, 255, 199, 1.0) : Colors.white,
          child: Text(message),
        ),
        Container(
          padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 3.0),
          child: Text(
            createdAt != null
                ? timeago.format(createdAt.toDate())
                : 'a moment ago',
            style: TextStyle(color: Colors.grey, fontSize: 11.0),
            textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
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
