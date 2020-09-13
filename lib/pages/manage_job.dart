import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/complete_job_screen.dart';
import 'package:khadamat/pages/dismiss_freelancer_screen.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/update_job_terms_request_screen.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_field.dart';
import 'package:khadamat/widgets/progress.dart';
import 'activity_feed.dart';

class ManageJob extends StatefulWidget {
  final String jobId;
  ManageJob({
    @required this.jobId,
  });

  @override
  _ManageJobState createState() => _ManageJobState();
}

class _ManageJobState extends State<ManageJob> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController professionalTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateRangeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  Job job;
  bool isLoading = false;
  bool drawerContentIsLoading = false;
  bool _professionalTitleValid = true;
  bool _jobDescriptionValid = true;
  bool _locationValid = true;
  bool _dateRangeValid = true;
  bool _priceValid = true;
  bool readOnly = true;
  bool isDialogueLoading = false;

  bool get hasRequest =>
      !job.hasOwnerUpdateRequest && !job.hasFreelancerUpdateRequest;
  bool get isJobOwner => currentUser.id == job.jobOwnerId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: jobsRef.document(widget.jobId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return linearProgress();
        else {
          DocumentSnapshot doc = snapshot.data;
          job = Job.fromDocument(doc);
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
            endDrawer: Drawer(
              elevation: 20.0,
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: buildNotifications(),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                        ),
                        isJobOwner
                            ? buildOwnerDrawer(context)
                            : buildFreelancerDrawer(context),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(kMore),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            isLoading ? linearProgress() : Container(),
                            readOnly
                                ? Column(
                                    children: [
                                      Container(),
                                      CustomField(
                                        text: job.jobDescription,
                                        label: kNewJobDescription,
                                      ),
                                      CustomField(
                                        text: job.location,
                                        label: kNewLocation,
                                      ),
                                      CustomField(
                                        text: job.dateRange,
                                        label: kNewDateRange,
                                      ),
                                      CustomField(
                                        text: job.price,
                                        label: kNewPrice,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      buildUpdateButtons(),
                                      buildProfessionalTitleField(),
                                      buildJobDescriptionField(),
                                      buildLocationField(),
                                      buildJobDateRangeTextField(),
                                      buildPriceField(),
                                    ],
                                  ),
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
      },
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
              setReadOnly(true);
            }),
        CustomButton(
            text: kCancel,
            function: () {
              setReadOnly(true);
            }),
      ],
    );
  }

  StreamBuilder buildNotifications() {
    return StreamBuilder(
      stream: getActivityFeed(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<ActivityFeedItem> feedItems = [];
        snapshot.data.documents.forEach((doc) {
          feedItems.add(ActivityFeedItem.fromDocument(doc));
        });
        return ListView(
          children: feedItems,
        );
      },
    );
  }

  Column buildFreelancerDrawer(BuildContext context) {
    return Column(
      children: [
        buildDrawerIconButtons(context),
        buildRequestDrawerItem(context),
        buildCompleteDrawerItem(context),
        ListTile(
          title: Text(kSignalAbuse),
          onTap: () {
            handleSignalAbuse();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Column buildOwnerDrawer(BuildContext context) {
    return Column(
      children: [
        buildDrawerIconButtons(context),
        buildRequestDrawerItem(context),
        buildCompleteDrawerItem(context),
        ListTile(
          title: Text(kDisposeCurrentFreelancer),
          onTap: () async {
            Navigator.pop(context);
            await showDismissFreelancerScreen(context, job: job);
          },
        ),
        ListTile(
          title: Text(kDeleteJob),
          onTap: () {
            Navigator.pop(context);
            handleDeleteJob(context);
          },
        ),
        ListTile(
          title: Text(kSignalAbuse),
          onTap: () {
            Navigator.pop(context);
            handleSignalAbuse();
          },
        ),
      ],
    );
  }

  Row buildDrawerIconButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildViewRequestUpdateJobTermsIconButton(context),
        buildCompleteJobIconButton(context),
      ],
    );
  }

  IconButton buildCompleteJobIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.check_circle_outline,
        size: 50.0,
      ),
      color: Colors.blue,
      disabledColor: Colors.grey,
      onPressed: isJobOwner
          ? job.isFreelancerCompleted
              ? () => showCompleteJobScreen(context, job: job)
              : null
          : job.isOwnerCompleted
              ? () => showCompleteJobScreen(context, job: job)
              : null,
    );
  }

  IconButton buildViewRequestUpdateJobTermsIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.update,
        size: 50.0,
      ),
      color: Colors.blue,
      disabledColor: Colors.grey,
      onPressed: isJobOwner
          ? job.hasFreelancerUpdateRequest
              ? () {
                  showUpdateJobTermsRequestScreen(context);
                  updateController();
                }
              : null
          : job.hasOwnerUpdateRequest
              ? () {
                  showUpdateJobTermsRequestScreen(context);
                  updateController();
                }
              : null,
    );
  }

  ListTile buildCompleteDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kCompleteJob),
      onTap: () async {
        Navigator.pop(context);
        await showCompleteJobScreen(context, job: job);
      },
    );
  }

  ListTile buildRequestDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kRequestUpdateJobTerms),
      onTap: () {
        Navigator.pop(context);
        if (hasRequest) {
          updateController();
          Timer(Duration(milliseconds: 500), () => setReadOnly(false));
        } else {
          SnackBar snackbar = SnackBar(
            content: Text(kHasUnresolvedUpdateRequest),
          );
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
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
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: kPriceHintText,
            errorText: _priceValid ? null : kDateRangeText,
          ),
        )
      ],
    );
  }

  Column buildProfessionalTitleField() {
    final bool autofocus = !readOnly;
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
          readOnly: readOnly,
          autofocus: autofocus,
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
          readOnly: readOnly,
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
          readOnly: readOnly,
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
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: kUpdateLocationHint,
            errorText: _locationValid ? null : kLocationErrorText,
          ),
        )
      ],
    );
  }

  void setReadOnly(bool readOnly) {
    setState(() {
      this.readOnly = readOnly;
    });
  }

  getActivityFeed() {
    return activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .where("jobId", isEqualTo: job.jobId)
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots();
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

    if (_priceValid &&
        _locationValid &&
        !job.hasOwnerUpdateRequest &&
        !job.hasFreelancerUpdateRequest) {
      await job
          .requestUpdateJobTermsFeed(
        requestOwnerName: currentUser.username,
        requestOwnerId: currentUser.id,
        newJobDescription: jobDescriptionController.text,
        newPrice: priceController.text,
        newLocation: locationController.text,
        newDateRange: dateRangeController.text,
      )
          .then((value) {
        SnackBar snackbar = SnackBar(content: Text(kJobUpdatedRequested));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      });
    }
  }

  Future<void> handleDeleteJob(context) async {
    if (isJobOwner) {
      if (job.isVacant) {
        job.deleteJob();
      } else {
        SnackBar snackbar = SnackBar(content: Text(kDisposeFreelancerFirst));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
    } else {
      SnackBar snackbar = SnackBar(content: Text(kNotJobOwner));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  showMoreOptions() {
    print("showMoreOptions");
  }

  signalAbuse() {
    print("signalAbuse");
  }

  void handleSignalAbuse() {
    //TODO handleSignalAbuse
  }

  void updateController() {
    setState(() {
      professionalTitleController.text = job.professionalTitle;
      jobDescriptionController.text = job.jobDescription;
      locationController.text = job.location;
      dateRangeController.text = job.dateRange;
      priceController.text = job.price;
    });
  }

  void setIsDialogueLoading(bool isLoading) {
    setState(() {
      isDialogueLoading = isLoading;
    });
  }

  Future<void> showUpdateJobTermsRequestScreen(BuildContext context) async {
    await showUpdateTermsScreen(context,
        job: job,
        newJobDescription: job.newJobDescription,
        newPrice: job.newPrice,
        newLocation: job.newLocation,
        newDateRange: job.newDateRange);
  }
}

showManageJob(
  BuildContext context, {
  @required String jobId,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ManageJob(
        jobId: jobId,
      ),
    ),
  );
}
