import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/widgets/header.dart';

class CompleteJobScreen extends StatelessWidget {
  final Job job;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CompleteJobScreen({
    @required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        titleText: kDisposeCurrentFreelancer,
      ),
      body: Container(),
    );
  }

  Future<void> handleCompleteJob() async {
    final bool isTimeValid = Timestamp.now()
            .toDate()
            .difference(job.jobFreelancerEnrollmentDate.toDate())
            .inHours >
        24;
    if (isTimeValid) {
      job.freelancerCompleteJob();
    } else {
      SnackBar snackbar = SnackBar(content: Text(kLessThan24Hours));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
    job.ownerCompleteJob();
  }
}

Future<void> showCompleteJobScreen(
  BuildContext context, {
  @required Job job,
}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompleteJobScreen(
          job: job,
        ),
      ));
}
