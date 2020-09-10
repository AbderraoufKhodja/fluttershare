import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/job_card.dart';
import 'package:khadamat/widgets/progress.dart';

class JobsScreen extends StatefulWidget {
  final String title;

  JobsScreen({@required this.title});
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

  buildListJobs() {
    return StreamBuilder(
        stream: getVacantJobsList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<JobCard> messages = [];
          snapshot.data.documents.forEach((doc) {
            messages.add(JobCard(Job.fromDocument(doc)));
          });
          return Container(
            child: ListView(
              children: messages,
            ),
          );
        });
  }

  Stream<QuerySnapshot> getVacantJobsList() {
    return jobsRef
        .where("professionalTitle", isEqualTo: widget.title)
        .where("isVacant", isEqualTo: true)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}

showMainJobsScreen(BuildContext context, {String title}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return JobsScreen(
      title: title,
    );
  }));
}
