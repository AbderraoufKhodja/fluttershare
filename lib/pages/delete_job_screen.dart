import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/header.dart';

class DeleteJobScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Job job;
  bool get isJobOwner => currentUser.id == job.jobOwnerId;

  DeleteJobScreen({
    @required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        titleText: kDeleteJob,
      ),
      body: Container(),
    );
  }

  Future<void> handleDeleteJob(context) async {
    if (isJobOwner) {
      if (job.isVacant) {
        job.deleteJob();
      } else {
        SnackBar snackbar = SnackBar(content: Text(kDisposeFreelancerFirst));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
    } else {
      SnackBar snackbar = SnackBar(content: Text(kNotJobOwner));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }
}

Future<void> showDeleteJobScreen(
  BuildContext context, {
  @required Job job,
}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteJobScreen(
          job: job,
        ),
      ));
}
