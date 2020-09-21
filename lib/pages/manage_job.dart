import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/update_job_terms_request_screen.dart';
import 'package:khadamat/pages/complete_job_screen.dart';
import 'package:khadamat/pages/delete_job_screen.dart';
import 'package:khadamat/pages/dismiss_freelancer_screen.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/update_job_terms_dialogue_screen.dart';
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

  Job job;
  bool isLoading = false;

  bool get hasRequest =>
      job.hasOwnerUpdateRequest || job.hasFreelancerUpdateRequest;

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
              title: Text(kManageJob),
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            endDrawer: buildDrawer(context),
            body: ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: [
                                job.isOwnerCompleted
                                    ? Icon(Icons.check_circle)
                                    : Column(
                                        children: [
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
                                      ),
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

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
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

  Widget buildFreelancerDrawer(BuildContext context) {
    return !job.isFreelancerCompleted
        ? Column(
            children: [
              buildUpdateIconButtons(context),
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
          )
        : Center(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 30.0,
                ),
                Text(kJobCompleted),
              ],
            ),
          );
  }

  Widget buildOwnerDrawer(BuildContext context) {
    return !job.isOwnerCompleted
        ? Column(
            children: [
              buildUpdateIconButtons(context),
              buildRequestDrawerItem(context),
              buildCompleteDrawerItem(context),
              ListTile(
                title: Text(kDismissCurrentFreelancer),
                onTap: () async {
                  await showDismissFreelancerScreen(context, job: job);
                },
              ),
              ListTile(
                title: Text(kDeleteJob),
                onTap: () {
                  showDeleteJobScreen(context, job: job);
                },
              ),
              ListTile(
                title: Text(kSignalAbuse),
                onTap: () {
                  handleSignalAbuse();
                },
              ),
            ],
          )
        : Center(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 30.0,
                ),
                Text(kJobCompleted),
              ],
            ),
          );
  }

  Row buildUpdateIconButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildUpdateJobTermsDialogueIconButton(context),
      ],
    );
  }
//
//  IconButton buildCompleteJobIconButton(BuildContext context) {
//    return IconButton(
//      icon: Icon(
//        Icons.check_circle_outline,
//        size: 50.0,
//      ),
//      color: Colors.blue,
//      disabledColor: Colors.grey,
//      onPressed: () {
//        final bool isTimeValid = Timestamp.now()
//                .toDate()
//                .difference(job.jobFreelancerEnrollmentDate.toDate())
//                .inHours >
//            24;
//        if (isTimeValid) {
//          showCompleteJobScreen(context, job: job);
//        } else {
//          Navigator.pop(context);
//          SnackBar snackbar = SnackBar(content: Text(kLessThan24Hours));
//          _scaffoldKey.currentState.showSnackBar(snackbar);
//        }
//      },
//    );
//  }

  IconButton buildUpdateJobTermsDialogueIconButton(BuildContext context) {
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
                  showUpdateJobTermsDialogueScreen(context,
                      job: job,
                      newJobDescription: job.newJobDescription,
                      newPrice: job.newPrice,
                      newLocation: job.newLocation,
                      newDateRange: job.newDateRange);
                }
              : null
          : job.hasOwnerUpdateRequest
              ? () {
                  showUpdateJobTermsDialogueScreen(context,
                      job: job,
                      newJobDescription: job.newJobDescription,
                      newPrice: job.newPrice,
                      newLocation: job.newLocation,
                      newDateRange: job.newDateRange);
                }
              : null,
    );
  }

  ListTile buildCompleteDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kCompleteJob),
      onTap: () {
        final bool isTimeValid = Timestamp.now()
                .toDate()
                .difference(job.jobFreelancerEnrollmentDate.toDate())
                .inHours >
            -1;
        if (isTimeValid) {
          showCompleteJobScreen(context, job: job);
        } else {
          Navigator.pop(context);
          SnackBar snackbar = SnackBar(content: Text(kLessThan24Hours));
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
    );
  }

  ListTile buildRequestDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kRequestUpdateJobTerms),
      onTap: () {
        Navigator.pop(context);
        if (!hasRequest) {
          showUpdateJobTermsRequestScreen(context, job: job);
        } else {
          SnackBar snackbar = SnackBar(
            content: Text(kHasUnresolvedUpdateRequest),
          );
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
    );
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

  showMoreOptions() {
    print("showMoreOptions");
  }

  signalAbuse() {
    print("signalAbuse");
  }

  void handleSignalAbuse() {
    //TODO handleSignalAbuse
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
