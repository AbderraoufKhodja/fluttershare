import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';

class JobsScreen extends StatefulWidget {
  @override
  _JobsScreen createState() => _JobsScreen();
}

class _JobsScreen extends State<JobsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: kJobsScreenTitle),
      body: Column(
        children: <Widget>[
          Expanded(child: buildListJobs()),
        ],
      ),
    );
  }
}

buildListJobs() {
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
        List<JobContainer> messages = [];
        snapshot.data.documents.forEach((doc) {
          messages.add(JobContainer.fromDocument(doc));
        });
        return ListView(
          children: messages,
        );
      });
}

class JobContainer extends StatelessWidget {
  final String jobId;
  final String jobOwnerId;
  final String jobOwnerName;
  final String applicantId;
  final String applicantName;
  final String jobTitle;
  final Map applications;

  JobContainer({
    this.jobId,
    this.jobOwnerId,
    this.jobOwnerName,
    this.applicantId,
    this.applicantName,
    this.jobTitle,
    this.applications,
  });

  factory JobContainer.fromDocument(DocumentSnapshot doc) {
    return JobContainer(
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
          onTap: () => showManageJob(context,
              jobId: jobId,
              applicantName: applicantName,
              applicantId: applicantId),
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

showJobsScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return JobsScreen();
  }));
}
