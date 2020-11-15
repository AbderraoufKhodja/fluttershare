import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_text_field.dart';
import 'package:khadamat/widgets/header.dart';

class DeleteJobScreen extends StatelessWidget {
  final Job job;

  DeleteJobScreen({
    @required this.job,
  });

  bool get isJobOwner => currentUser.id == job.jobOwnerId;
  final TextEditingController reasonOfDeleteController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        titleText: kDeleteJob,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: CustomTextField(
                  label: kReasonOfDeleteJob,
                  controller: reasonOfDeleteController),
            ),
            CustomButton(
              padding: 5.0,
              fillColor: Colors.amber,
              widthFactor: 2,
              heightFactor: 1.2,
              text: kDelete,
              function: () => handleDeleteJob(context),
            )
          ],
        ),
      ),
    );
  }

  Future<void> handleDeleteJob(BuildContext context) async {
    await job
        .deleteJob(deletReason: reasonOfDeleteController.text)
        .then((value) => job.isVacant = false);
    Navigator.pop(context);
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
