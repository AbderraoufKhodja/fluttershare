import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_field.dart';
import 'package:khadamat/widgets/header.dart';

class UpdateJobTermsDialogueScreen extends StatelessWidget {
  final Job job;
  final String newJobDescription;
  final String newPrice;
  final Map newLocation;
  final String newDateRange;

  UpdateJobTermsDialogueScreen({
    @required this.job,
    @required this.newJobDescription,
    @required this.newPrice,
    @required this.newLocation,
    @required this.newDateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        titleText: kUpdateConfirmCancel,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                CustomField(
                  text: newJobDescription,
                  label: kNewJobDescription,
                ),
                CustomField(
                  text: newLocation.toString(),
                  label: kNewLocation,
                ),
                CustomField(
                  text: newDateRange,
                  label: kNewDateRange,
                ),
                CustomField(
                  text: newPrice,
                  label: kNewPrice,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CustomButton(
                margin: 10.0,
                text: kAccept,
                function: () async {
                  await handleAcceptUpdateJobTerms();
                  Navigator.pop(context);
                },
              ),
              CustomButton(
                margin: 10.0,
                text: kReject,
                function: () async {
                  await handleRejectUpdateJobTerms();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Future<void> handleAcceptUpdateJobTerms() {
    return job.acceptUpdateJobTerms(
      decisionOwnerId: currentUser.uid.value,
      decisionOwnerName: currentUser.username.value,
    );
  }

  Future<void> handleRejectUpdateJobTerms() async {
    return job.rejectUpdateJobTerms(
      decisionOwnerName: currentUser.username.value,
      decisionOwnerId: currentUser.uid.value,
    );
  }
}

Future<void> showUpdateJobTermsDialogueScreen(
  BuildContext context, {
  @required Job job,
  @required String newJobDescription,
  @required String newPrice,
  @required Map newLocation,
  @required String newDateRange,
}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateJobTermsDialogueScreen(
            job: job,
            newJobDescription: newJobDescription,
            newPrice: newPrice,
            newLocation: newLocation,
            newDateRange: newDateRange),
      ));
}
