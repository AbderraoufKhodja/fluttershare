import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';

class MainJobsScreen extends StatefulWidget {
  final String title;

  MainJobsScreen({@required this.title});
  @override
  _JobsScreen createState() => _JobsScreen();
}

class _JobsScreen extends State<MainJobsScreen> {
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

  buildListJobs() {
    return StreamBuilder(
        stream: getVacantJobsList(),
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

  Stream<QuerySnapshot> getVacantJobsList() {
    return jobsRef
        .where("professionalTitle", isEqualTo: widget.title)
        .where("isVacant", isEqualTo: true)
        .snapshots();
  }
}

class JobContainer extends StatelessWidget {
  final String jobId;
  final String jobOwnerId;
  final String jobOwnerName;
  final String applicantId;
  final String applicantName;
  final String professionalTitle;
  final Map applications;

  JobContainer({
    this.jobId,
    this.jobOwnerId,
    this.jobOwnerName,
    this.applicantId,
    this.applicantName,
    this.professionalTitle,
    this.applications,
  });

  factory JobContainer.fromDocument(DocumentSnapshot doc) {
    return JobContainer(
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
          onTap: () => showManageJob(context,
              jobId: jobId,
              applicantName: applicantName,
              applicantId: applicantId),
          child: ListTile(
            title: Text(professionalTitle ?? ""),
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

showMainJobsScreen(BuildContext context, {String title}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return MainJobsScreen(
      title: title,
    );
  }));
}
