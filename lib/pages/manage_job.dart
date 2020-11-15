import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/messages.dart';
import 'package:khadamat/pages/signal_abuse_screen.dart';
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
  bool get hasJobFreelancer => job.jobFreelancerId != null;

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
            body: buildJobInfoListView(),
          );
        }
      },
    );
  }

  ListView buildJobInfoListView() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(jobStatus()),
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
        ),
      ],
    );
  }

  String jobStatus() {
    // job owner completed
    if (job.isOwnerCompleted) return kOwnerCompleted;

    // job freelancer completed
    if (job.isFreelancerCompleted) return kFreelancerCompleted;

    // job freelancer dismissed
    if (job.jobFreelancerId != currentUser.id &&
        job.jobOwnerId != currentUser.id) return kFreelancerDismissed;

    // job on going
    if (job.isVacant == false && job.applications.containsValue(true))
      return kJobOnGoing;

    //job has no freelancer
    if (job.isVacant == true && job.applications.containsValue(true) == false)
      return kHasNoJobFreelancer;

    // job canceled
    if (job.isVacant == false) return kJobCanceled;

    // job on unknown state
    return kUnknownStatu;
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
                    color: Colors.amberAccent,
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
    return jobStatus() == kOwnerCompleted
        ? Center(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 90.0,
                ),
                Text(kJobCompleted),
              ],
            ),
          )
        : jobStatus() == kFreelancerCompleted
            ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 90.0,
                    ),
                    Text(kFreelancerCompleted),
                  ],
                ),
              )
            : jobStatus() == kFreelancerDismissed
                ? Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.clear,
                          size: 90.0,
                        ),
                        Text(kFreelancerDismissed),
                      ],
                    ),
                  )
                : jobStatus() == kJobOnGoing
                    ? Column(
                        children: [
                          buildUpdateIconButtons(context),
                          buildChatDrawerItem(context),
                          buildRequestDrawerItem(context),
                          buildCompleteDrawerItem(context),
                          ListTile(
                            title: Text(kSignalAbuse),
                            onTap: () {
                              showSignalAbuseScreen(context, job: job);
                            },
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.clear,
                              size: 90.0,
                            ),
                            Text(kUnknownStatu),
                          ],
                        ),
                      );
  }

  Widget buildOwnerDrawer(BuildContext context) {
    return jobStatus() == kOwnerCompleted
        ? Center(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 90.0,
                ),
                Text(kJobCompleted),
              ],
            ),
          )
        : jobStatus() == kJobCanceled
            ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.clear,
                      size: 90.0,
                    ),
                    Text(kJobCanceled),
                  ],
                ),
              )
            : Column(
                children: [
                  buildUpdateIconButtons(context),
                  buildChatDrawerItem(context),
                  buildRequestDrawerItem(context),
                  buildCompleteDrawerItem(context),
                  buildDismissFreelancerDrawerItem(context),
                  buildSignalAbuseDrawerItem(context),
                  buildDeletJobDrawerItem(context),
                ],
              );
  }

  ListTile buildSignalAbuseDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kSignalAbuse),
      onTap: () {
        if (hasJobFreelancer)
          showSignalAbuseScreen(context, job: job);
        else {
          Navigator.pop(context);
          SnackBar snackbar = SnackBar(content: Text(kHasNoJobFreelancer));
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
    );
  }

  ListTile buildDeletJobDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kDeleteJob),
      onTap: () {
        showDeleteJobScreen(context, job: job);
      },
    );
  }

  ListTile buildChatDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kShowChat),
      onTap: () {
        if (hasJobFreelancer) {
          final String jobChatId = job.jobOwnerId + "&&" + job.jobFreelancerId;
          showMessages(
            context,
            jobChatId: jobChatId,
            jobId: job.jobId,
            professionalTitle: job.professionalTitle,
            jobTitle: job.jobTitle,
            jobOwnerId: job.jobOwnerId,
            jobOwnerName: job.jobOwnerName,
          );
        } else {
          Navigator.pop(context);
          SnackBar snackbar = SnackBar(content: Text(kHasNoJobFreelancer));
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
    );
  }

  ListTile buildDismissFreelancerDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kDismissCurrentFreelancer),
      onTap: () {
        if (hasJobFreelancer)
          showDismissFreelancerScreen(context, job: job);
        else {
          Navigator.pop(context);
          SnackBar snackbar = SnackBar(content: Text(kHasNoJobFreelancer));
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
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
      title: Text(kJobComplete),
      onTap: () {
        if (hasJobFreelancer) {
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
        } else {
          Navigator.pop(context);
          SnackBar snackbar = SnackBar(
            content: Text(kHasNoJobFreelancer),
          );
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
      },
    );
  }

  ListTile buildRequestDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kRequestUpdateJobTerms),
      onTap: () {
        if (!hasRequest && hasJobFreelancer) {
          showUpdateJobTermsRequestScreen(context, job: job);
        } else if (hasRequest) {
          Navigator.pop(context);
          SnackBar snackbar = SnackBar(
            content: Text(kHasUnresolvedUpdateRequest),
          );
          _scaffoldKey.currentState.showSnackBar(snackbar);
        } else if (!hasJobFreelancer) {
          Navigator.pop(context);
          SnackBar snackbar = SnackBar(
            content: Text(kHasNoJobFreelancer),
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
