import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_text_field.dart';
import 'package:khadamat/widgets/header.dart';

class SignalAbuseScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Job job;
  final TextEditingController natureOfAbuseController = TextEditingController();
  bool get isJobOwner => currentUser.id == job.jobOwnerId;

  SignalAbuseScreen({
    @required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        titleText: kContactTeam,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: CustomTextField(
                  label: kMessageForTheTeam,
                  controller: natureOfAbuseController),
            ),
            CustomButton(
              padding: 5.0,
              fillColor: Colors.amber,
              widthFactor: 2,
              heightFactor: 1.2,
              text: kSubmit,
              function: handleSignalAbuse,
            )
          ],
        ),
      ),
    );
  }

  Future<void> handleSignalAbuse() async {
    return job.uploadTeamNotification(
        messageText: natureOfAbuseController.text, type: "signalAbuse");
  }
}

Future<void> showSignalAbuseScreen(
  BuildContext context, {
  @required Job job,
}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignalAbuseScreen(
          job: job,
        ),
      ));
}
