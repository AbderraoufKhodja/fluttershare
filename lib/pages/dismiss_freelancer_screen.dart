import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/widgets/header.dart';

class DismissFreelancerScreen extends StatelessWidget {
  final Job job;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DismissFreelancerScreen({
    @required this.job,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        titleText: kDismissCurrentFreelancer,
      ),
      body: Container(),
    );
  }
}

Future<void> showDismissFreelancerScreen(
  BuildContext context, {
  @required Job job,
}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DismissFreelancerScreen(
          job: job,
        ),
      ));
}
