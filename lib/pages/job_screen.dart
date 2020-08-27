import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';

class JobScreen extends StatelessWidget {
  final String userId;
  final String jobId;
  final Job job;

  //TODO build the screen

  JobScreen({this.userId, this.job, this.jobId});

  @override
  Widget build(BuildContext context) {
    return job != null
        ? Center(
            child: Scaffold(
              appBar: header(context,
                  titleText: kJobScreenTitle,
                  hasAction: true,
                  action: job.handleApplyJob()),
              body: ListView(
                children: <Widget>[
                  Container(
                    child: Text(job.category),
                  )
                ],
              ),
            ),
          )
        : FutureBuilder(
            future: jobsRef
                .document(userId)
                .collection('userJobs')
                .document(jobId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              Job post = Job.fromDocument(snapshot.data);
              return Center(
                child: Scaffold(
                  appBar: header(context, titleText: post.description),
                  body: ListView(
                    children: <Widget>[
                      Container(
                        child: Text(job.category),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
