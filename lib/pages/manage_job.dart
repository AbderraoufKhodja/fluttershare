import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/progress.dart';

class ManageJob extends StatefulWidget {
  final String jobId;
  ManageJob({
    @required this.jobId,
  });

  @override
  _ManageJobState createState() => _ManageJobState();
}

class _ManageJobState extends State<ManageJob> {
  List<Choice> choices = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController professionalTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateRangeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  Job job;
  bool isLoading = false;
  bool _professionalTitleValid = true;
  bool _jobDescriptionValid = true;
  bool _locationValid = true;
  bool _dateRangeValid = true;
  bool _priceValid = true;

  @override
  void initState() {
    super.initState();
    getJob();
    setAppBarMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          kEditJob,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          PopupMenuButton<Choice>(
            onSelected: (selected) => selected.onTap(),
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildProfessionalTitleField(),
                            buildJobDescriptionField(),
                            buildLocationField(),
                            buildJobDateRangeTextField(),
                            buildPriceField(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  getJob() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await jobsRef.document(widget.jobId).get();
    job = Job.fromDocument(doc);
    jobDescriptionController.text = job.jobDescription;
    professionalTitleController.text = job.professionalTitle;
    priceController.text = job.price;
    locationController.text = job.location;
    dateRangeController.text = job.dateRange;
    priceController.text = job.price;
    setState(() {
      isLoading = false;
    });
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

  Column buildProfessionalTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              kProfessionalTitle,
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        TextField(
          controller: professionalTitleController,
          readOnly: true,
          decoration: InputDecoration(
            hintText: kProfessionalTitleHint,
            errorText: _professionalTitleValid ? null : kDateRangeText,
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
          readOnly: true,
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
          controller: locationController,
          decoration: InputDecoration(
            hintText: kUpdateLocationHint,
            errorText: _locationValid ? null : kLocationErrorText,
          ),
        )
      ],
    );
  }

  Future<void> handleRequestUpdateJobTerms() async {
    setState(() {
      priceController.text.trim().length < 3 || priceController.text.isEmpty
          ? _priceValid = false
          : _priceValid = true;
      locationController.text.trim().length > 100
          ? _locationValid = false
          : _locationValid = true;
    });

    if (_priceValid && _locationValid) {
      job
          .requestUpdateJobTermsFeed(
        requestOwnerName: currentUser.username,
        requestOwnerId: currentUser.id,
        newPrice: priceController.text,
        newLocation: locationController.text,
        newDateRange: dateRangeController.text,
      )
          .then((value) {
        SnackBar snackbar = SnackBar(content: Text(kJobUpdatedRequested));
        _scaffoldKey.currentState.showSnackBar(snackbar);
        Timer(Duration(seconds: 2), () => Navigator.pop(context));
      });
    }
  }

  Future<void> handleAcceptUpdateJobTerms() async {
    job.acceptUpdateJobTerms(
      requestOwnerName: currentUser.username,
      requestOwnerId: currentUser.id,
      newPrice: priceController.text,
      newLocation: locationController.text,
      newDateRange: dateRangeController.text,
    );
  }

  Future<void> handleRejectUpdateJobTerms() async {
    job.rejectUpdateJobTerms(
      requestOwnerName: currentUser.username,
      requestOwnerId: currentUser.id,
      newPrice: priceController.text,
      newLocation: locationController.text,
      newDateRange: dateRangeController.text,
    );
  }

  cancel() {
    Navigator.pop(context);
  }

  Future<void> handleDeleteJob() async {
    job.freelancerDeleteJob();
    job.ownerDeleteJob();
  }

  Future<void> handleCompleteJob() async {
    final bool isTimeValid = Timestamp.now()
            .toDate()
            .difference(job.jobFreelancerEnrollmentDate.toDate())
            .inHours >
        24;
    if (isTimeValid) {
      showDisposeDialogue(context);
      job.freelancerCompleteJob();
    } else {
      SnackBar snackbar = SnackBar(content: Text(kLessThan24Hours));
      Scaffold.of(context).showSnackBar(snackbar);
    }
    job.ownerCompleteJob();
  }

  setAppBarMenu() {
    choices = [
      Choice(title: kRequestUpdateJobTerms, onTap: handleRequestUpdateJobTerms),
      Choice(title: kDeleteJob, onTap: handleDeleteJob),
      Choice(title: kCompleteJob, onTap: handleCompleteJob),
      Choice(
          title: kDisposeCurrentFreelancer,
          onTap: handleDisposeCurrentFreelancer),
      Choice(title: kSignalAbuse, onTap: signalAbuse),
      Choice(title: kMore, onTap: showMoreOptions),
    ];
  }

  showMoreOptions() {
    print("showMoreOptions");
  }

  signalAbuse() {
    print("signalAbuse");
  }

  handleDisposeCurrentFreelancer() {
    showDisposeDialogue(context);
    job.disposeCurrentFreelancerAndDeleteJob();
  }

  showDisposeDialogue(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return Container(
            color: Colors.blue,
            height: 20,
            width: 30,
          );
        });
  }
}

class Choice {
  Choice({this.title, this.onTap});

  final Function onTap;
  final String title;
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

showManageJob(BuildContext context,
    {@required String jobId,
    @required String jobFreelancerId,
    @required String jobFreelancerName,
    @required String jobOwnerId,
    bool hasRequest = false}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ManageJob(
        jobId: jobId,
      ),
    ),
  );
}
