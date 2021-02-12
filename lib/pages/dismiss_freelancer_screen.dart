import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_text_field.dart';
import 'package:khadamat/widgets/header.dart';

class DismissFreelancerScreen extends StatefulWidget {
  final Job job;

  DismissFreelancerScreen({
    @required this.job,
  });

  @override
  _DismissFreelancerScreenState createState() =>
      _DismissFreelancerScreenState();
}

class _DismissFreelancerScreenState extends State<DismissFreelancerScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController reviewController = TextEditingController();

  double freelancerWorkQuality;

  double freelancerAttitude;

  double freelancerTimeManagement;

  double ownerRating;

  bool get isJobFreelancer => currentUser.uid == job.jobFreelancerId;

  bool get isJobOwner => currentUser.uid == job.jobOwnerId;

  Job get job => widget.job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        titleText: kDismissCurrentFreelancerAndPostJobAgain,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  buildRatingColumn(),
                  CustomTextField(label: kReview, controller: reviewController),
                ],
              ),
            ),
            CustomButton(
              padding: 5.0,
              fillColor: Colors.amber,
              widthFactor: 2,
              heightFactor: 1.2,
              text: kDismiss,
              function: () => dismissFreelancer(context),
            )
          ],
        ),
      ),
    );
  }

  Column buildRatingColumn() {
    return Column(
      children: [
        isJobOwner
            ? Column(
                children: [
                  buildRatingBar(
                    title: kFreelancerWorkQuality,
                    onRatingUpdate: (rating) => freelancerWorkQuality = rating,
                  ),
                  buildRatingBar(
                    title: kFreelancerAttitude,
                    onRatingUpdate: (rating) => freelancerAttitude = rating,
                  ),
                  buildRatingBar(
                    title: kFreelancerTimeManagement,
                    onRatingUpdate: (rating) =>
                        freelancerTimeManagement = rating,
                  ),
                ],
              )
            : buildRatingBar(
                title: kOwnerRating,
                onRatingUpdate: (rating) => ownerRating = rating,
              ),
      ],
    );
  }

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
                child: RatingBar.builder(
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

  Future<void> dismissFreelancer(BuildContext context) async {
    isJobOwner
        ? await job
            .handleDismissAndReviewFreelancer(
            freelancerReview: reviewController.text,
            freelancerQualityRating: freelancerWorkQuality,
            freelancerAttitudeRating: freelancerAttitude,
            freelancerTimeManagementRating: freelancerTimeManagement,
          )
            .then((value) {
            job.jobFreelancerId = null;
            job.jobFreelancerName = null;
            job.jobFreelancerEmail = null;
            job.jobState = "open";
          })
        : await job
            .freelancerQuitAndReviewOwner(
            ownerReview: reviewController.text,
            ownerRating: ownerRating,
          )
            .then((value) {
            job.jobFreelancerId = null;
            job.jobFreelancerName = null;
            job.jobFreelancerEmail = null;
            job.jobState = "open";
          });
    Navigator.pop(context);
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
