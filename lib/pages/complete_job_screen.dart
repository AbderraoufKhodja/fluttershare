import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_text_form_field.dart';
import 'package:khadamat/widgets/header.dart';

class CompleteJobScreen extends StatefulWidget {
  final Job job;

  CompleteJobScreen({
    @required this.job,
  });

  @override
  _CompleteJobScreenState createState() => _CompleteJobScreenState();
}

class _CompleteJobScreenState extends State<CompleteJobScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController reviewController = TextEditingController();
  double jobQualityRating;
  double mannersRating;
  double timeManagementRating;

  bool get isJobOwner => job.jobOwnerId == currentUser.id;
  Job get job => widget.job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        titleText: kCompleteJob,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildRatingColumn(),
                  buildReviewColumn(),
                ],
              ),
            ),
            CustomButton(
              padding: 5.0,
              fillColor: Colors.amber,
              widthFactor: 2,
              heightFactor: 1.2,
              text: kSubmitAndComplete,
              function: handleCompleteAndReviewJob,
            )
          ],
        ),
      ),
    );
  }

  Column buildReviewColumn() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15.0),
          padding: EdgeInsets.only(top: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            color: Colors.grey.withOpacity(0.5),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(kReview),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: Colors.white,
                ),
                child: CustomTextFormField(
                  controller: reviewController,
                  hint: null,
                  maxLines: 7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column buildRatingColumn() {
    return Column(
      children: [
        buildRatingBar(
          title: kFreelancerWorkQuality,
          onRatingUpdate: (rating) => jobQualityRating = rating,
        ),
        isJobFreelancer
            ? Column(
                children: [
                  buildRatingBar(
                    title: kFreelancerManners,
                    onRatingUpdate: (rating) => mannersRating = rating,
                  ),
                  buildRatingBar(
                    title: kFreelancerTimeManagement,
                    onRatingUpdate: (rating) => timeManagementRating = rating,
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  bool get isJobFreelancer => currentUser.id == job.jobFreelancerId;

  Column buildRatingBar(
      {String title, Function(double rating) onRatingUpdate}) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 15.0),
          padding: EdgeInsets.only(top: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            color: Colors.grey.withOpacity(0.5),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(title),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                padding: EdgeInsets.all(5.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: Colors.white,
                ),
                child: RatingBar(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: onRatingUpdate,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> handleCompleteAndReviewJob() async {
    isJobOwner
        ? await job.ownerCompleteAndReviewJob(
            freelancerReview: reviewController.text,
            freelancerJobQualityRating: jobQualityRating,
            freelancerMannersRating: mannersRating,
            freelancerTimeManagementRating: timeManagementRating)
        : await job.freelancerCompleteAndReviewJob(
            ownerReview: reviewController.text,
            ownerMannersRating: mannersRating);
    Navigator.pop(context);
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
