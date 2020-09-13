import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_field.dart';
import 'package:khadamat/widgets/header.dart';

class UpdateJobTermsRequestScreen extends StatelessWidget {
  final Job job;
  final String newJobDescription;
  final String newPrice;
  final String newLocation;
  final String newDateRange;
  UpdateJobTermsRequestScreen({
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
              children: [
                CustomField(
                  text: kNewJobDescription,
                  label: newJobDescription,
                ),
                CustomField(
                  text: kNewLocation,
                  label: newLocation,
                ),
                CustomField(
                  text: kNewDateRange,
                  label: newDateRange,
                ),
                CustomField(
                  text: kNewPrice,
                  label: newPrice,
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
      decisionOwnerId: currentUser.id,
      decisionOwnerName: currentUser.username,
    );
  }

  Future<void> handleRejectUpdateJobTerms() async {
    return job.rejectUpdateJobTerms(
      decisionOwnerName: currentUser.username,
      decisionOwnerId: currentUser.id,
    );
  }
}

Future<void> showUpdateTermsScreen(
  BuildContext context, {
  @required Job job,
  @required String newJobDescription,
  @required String newPrice,
  @required String newLocation,
  @required String newDateRange,
}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateJobTermsRequestScreen(
            job: job,
            newJobDescription: newJobDescription,
            newPrice: newPrice,
            newLocation: newLocation,
            newDateRange: newDateRange),
      ));
}
