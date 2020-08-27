import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/messages.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';

class MessageScreen extends StatefulWidget {
  @override
  MessageScreenState createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: kMessagesScreenTitle),
      body: Column(
        children: <Widget>[
          Expanded(child: buildListMessages()),
        ],
      ),
    );
  }
}

buildListMessages() {
  return StreamBuilder(
      stream: usersRef
          .document(currentUser.id)
          .collection('userJobs')
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<MessageContainer> messages = [];
        snapshot.data.documents.forEach((doc) {
          messages.add(MessageContainer.fromDocument(doc));
        });
        return ListView(
          children: messages,
        );
      });
}

class MessageContainer extends StatelessWidget {
  final String jobId;
  final String jobOwnerId;
  final String jobOwnerName;
  final String applicantId;
  final String applicantName;
  final String jobTitle;
  final Map applications;

  MessageContainer({
    this.jobId,
    this.jobOwnerId,
    this.jobOwnerName,
    this.applicantId,
    this.applicantName,
    this.jobTitle,
    this.applications,
  });

  factory MessageContainer.fromDocument(DocumentSnapshot doc) {
    return MessageContainer(
      jobId: doc['jobId'],
      jobOwnerId: doc['jobOwnerId'],
      jobOwnerName: doc['jobOwnerName'],
      applicantId: doc['applicantId'],
      applicantName: doc['applicantName'],
      jobTitle: doc['jobTitle'],
      applications: doc['applications'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => showMessages(context,
              jobId: jobId,
              jobOwnerId: jobOwnerId,
              jobOwnerName: jobOwnerName,
              applicantId: applicantId,
              applicantName: applicantName,
              jobTitle: jobTitle),
          child: ListTile(
            title: Text(jobTitle),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(kBlankProfileUrl),
            ),
            subtitle: Text("job owner: $jobOwnerName"),
          ),
        ),
        Divider(),
      ],
    );
  }
}

showMessageScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return MessageScreen();
  }));
}
