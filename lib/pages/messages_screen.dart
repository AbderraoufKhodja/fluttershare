import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/messages.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';

class MessagesScreen extends StatefulWidget {
  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
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
          .orderBy("createdAt", descending: false)
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
  final String professionalTitle;
  final Map applications;

  MessageContainer({
    this.jobId,
    this.jobOwnerId,
    this.jobOwnerName,
    this.applicantId,
    this.applicantName,
    this.professionalTitle,
    this.applications,
  });

  factory MessageContainer.fromDocument(DocumentSnapshot doc) {
    return MessageContainer(
      jobId: doc['jobId'],
      jobOwnerId: doc['jobOwnerId'],
      jobOwnerName: doc['jobOwnerName'],
      applicantId: doc['applicantId'],
      applicantName: doc['applicantName'],
      professionalTitle: doc['professionalTitle'],
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
              professionalTitle: professionalTitle),
          child: ListTile(
            title: Text(professionalTitle),
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
    return MessagesScreen();
  }));
}
