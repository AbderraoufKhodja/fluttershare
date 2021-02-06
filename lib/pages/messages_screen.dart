import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/messages.dart';
import 'package:khadamat/widgets/progress.dart';

class MessagesScreen extends StatefulWidget {
  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: buildListMessages()),
        ],
      ),
    );
  }
}

buildListMessages() {
  return FutureBuilder(
      future: usersRef
          .doc(currentUser.uid)
          .collection('userChats')
          .orderBy("createdAt", descending: false)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<MessageContainer> messages = [];
        snapshot.data.docs.forEach((doc) {
          messages.add(MessageContainer.fromDocument(doc));
        });
        return ListView(
          children: messages,
        );
      });
}

class MessageContainer extends StatelessWidget {
  final String jobChatId;
  final String jobId;
  final String professionalTitle;
  final String jobTitle;
  final String jobOwnerId;
  final String jobOwnerName;

  MessageContainer({
    this.jobChatId,
    this.jobId,
    this.professionalTitle,
    this.jobTitle,
    this.jobOwnerId,
    this.jobOwnerName,
  });

  factory MessageContainer.fromDocument(DocumentSnapshot doc) {
    return MessageContainer(
      jobChatId: doc['jobChatId'],
      jobId: doc['jobId'],
      professionalTitle: doc['professionalTitle'],
      jobTitle: doc['jobTitle'],
      jobOwnerId: doc['jobOwnerId'],
      jobOwnerName: doc['jobOwnerName'],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(jobOwnerName);
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => showMessages(context,
              jobChatId: jobChatId,
              jobId: jobId,
              jobOwnerId: jobOwnerId,
              jobOwnerName: jobOwnerName,
              professionalTitle: professionalTitle,
              jobTitle: jobTitle),
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

showMessagesScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return MessagesScreen();
  }));
}
