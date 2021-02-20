import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/header.dart';

class UpdateJobTermsScreenRequest extends StatefulWidget {
  final Job job;

  UpdateJobTermsScreenRequest({
    @required this.job,
  });

  @override
  _UpdateJobTermsScreenRequestState createState() =>
      _UpdateJobTermsScreenRequestState();
}

class _UpdateJobTermsScreenRequestState
    extends State<UpdateJobTermsScreenRequest> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController jobDescriptionController = TextEditingController();
  GeoFirePoint locationGeoPoint;
  TextEditingController dateRangeController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool _jobDescriptionValid = true;
  bool _locationValid = true;
  bool _dateRangeValid = true;
  bool _priceValid = true;

  Job get job => widget.job;

  @override
  void initState() {
    super.initState();
    updateController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        titleText: kRequestUpdateJobTerms,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10.0),
        children: [
          buildUpdateButtons(),
          buildJobDescriptionField(),
          buildLocationField(),
          buildJobDateRangeTextField(),
          buildPriceField(),
        ],
      ),
    );
  }

  Column buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              kJobPrice,
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        TextField(
          controller: priceController,
          decoration: InputDecoration(
            hintText: kPriceHintText,
            errorText: _priceValid ? null : kDateRangeText,
          ),
        )
      ],
    );
  }

  Column buildJobDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              kJobDescription,
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        TextField(
          controller: jobDescriptionController,
          decoration: InputDecoration(
            hintText: kJobDescriptionHint,
            errorText: _jobDescriptionValid ? null : kDateRangeText,
          ),
        )
      ],
    );
  }

  Column buildJobDateRangeTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              kDateRange,
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        TextField(
          controller: dateRangeController,
          decoration: InputDecoration(
            hintText: kDateRangeHint,
            errorText: _dateRangeValid ? null : kDateRangeText,
          ),
        )
      ],
    );
  }

  Column buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            kLocationField,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        TextField(
          controller: null,
          decoration: InputDecoration(
            hintText: kUpdateLocationHint,
            errorText: _locationValid ? null : kLocationErrorText,
          ),
        )
      ],
    );
  }

  Row buildUpdateButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
            text: kSubmitRequest,
            function: () {
              handleRequestUpdateJobTerms();
            }),
        CustomButton(text: kCancel, function: () {}),
      ],
    );
  }

  void updateController() {
    setState(() {
      jobDescriptionController.text = job.jobDescription.value;
      locationGeoPoint = job.location.value;
      dateRangeController.text = job.dateRange.value;
      priceController.text = job.price.value;
    });
  }

  Future<void> handleRequestUpdateJobTerms() async {
    setState(() {
      priceController.text.trim().length < 3 || priceController.text.isEmpty
          ? _priceValid = false
          : _priceValid = true;
      locationGeoPoint != null ? _locationValid = false : _locationValid = true;
    });

    if (_priceValid &&
        _locationValid &&
        !job.hasOwnerUpdateRequest.value &&
        !job.hasFreelancerUpdateRequest.value) {
      await job
          .requestUpdateJobTermsFeed(
        requestOwnerName: currentUser.username.value,
        requestOwnerId: currentUser.uid.value,
        newJobDescription: jobDescriptionController.text,
        newPrice: priceController.text,
        newLocation: locationGeoPoint,
        newDateRange: dateRangeController.text,
      )
          .then((value) {
        SnackBar snackbar = SnackBar(content: Text(kJobUpdatedRequested));
        _scaffoldKey.currentState.showSnackBar(snackbar);
        Timer(Duration(seconds: 2), () => Navigator.pop(context));
      });
    }
  }
}

Future<void> showUpdateJobTermsRequestScreen(
  BuildContext context, {
  @required Job job,
}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateJobTermsScreenRequest(
          job: job,
        ),
      ));
}
