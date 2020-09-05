import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/progress.dart';

class ManageJob extends StatefulWidget {
  final String jobId;
  final String applicantId;
  final String applicantName;
  ManageJob({this.jobId, this.applicantId, this.applicantName});

  @override
  _ManageJobState createState() => _ManageJobState();
}

class _ManageJobState extends State<ManageJob> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController professionalTitleController = TextEditingController();
  TextEditingController jobScheduleController = TextEditingController();
  Job job;
  bool isLoading = false;
  bool hasApplicant = false;
  bool _priceValid = true;
  bool _locationValid = true;
  bool _professionalTitleValid = true;
  bool _jobScheduleValid = true;

  @override
  void initState() {
    super.initState();
    getJob();
    checkIfHasApplicant();
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
                            buildPriceField(),
                            buildLocationField(),
                            buildJobScheduleField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: updateJobData,
                        child: Text(
                          kUpdateJob,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
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
    priceController.text = job.price;
    locationController.text = job.location;
    professionalTitleController.text = job.professionalTitle;
    jobScheduleController.text = job.dateRange;
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
            errorText: _priceValid ? null : kPriceErrorText,
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
          decoration: InputDecoration(
            hintText: kProfessionalTitleHint,
            errorText: _professionalTitleValid ? null : kPriceErrorText,
          ),
        )
      ],
    );
  }

  Column buildJobScheduleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              kJobSchedule,
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        TextField(
          controller: jobScheduleController,
          decoration: InputDecoration(
            hintText: kJobScheduleHint,
            errorText: _jobScheduleValid ? null : kPriceErrorText,
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

  updateJobData() {
    setState(() {
      priceController.text.trim().length < 3 || priceController.text.isEmpty
          ? _priceValid = false
          : _priceValid = true;
      locationController.text.trim().length > 100
          ? _locationValid = false
          : _locationValid = true;
    });

    if (_priceValid && _locationValid) {
      jobsRef.document(widget.jobId).updateData({
        "price": priceController.text,
        "location": locationController.text,
        "applications.${widget.applicantId}": true,
      });
      SnackBar snackbar = SnackBar(content: Text(kJobUpdated));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  cancel() {
    Navigator.pop(context);
  }

  checkIfHasApplicant() {
    hasApplicant = widget.applicantId != null;
  }
}

showManageJob(BuildContext context,
    {@required String jobId, String applicantId, String applicantName}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ManageJob(
        jobId: jobId,
        applicantId: applicantId,
        applicantName: applicantName,
      ),
    ),
  );
}
