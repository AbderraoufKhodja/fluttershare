import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/activity_feed.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/messages.dart';
import 'package:khadamat/pages/signal_abuse_screen.dart';
import 'package:khadamat/pages/update_job_terms_request_screen.dart';
import 'package:khadamat/pages/complete_job_screen.dart';
import 'package:khadamat/pages/delete_job_screen.dart';
import 'package:khadamat/pages/dismiss_freelancer_screen.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/update_job_terms_dialogue_screen.dart';
import 'package:khadamat/widgets/activity_feed_item.dart';
import 'package:khadamat/widgets/custom_field.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Job job;
  bool isLoading = false;

  bool get hasRequest => job.hasOwnerUpdateRequest.value || job.hasFreelancerUpdateRequest.value;

  bool get isJobOwner => currentUser.uid.value == job.jobOwnerId.value;
  bool get hasJobFreelancer =>
      job.jobState.value == "onGoing" &&
      job.applications.value.containsValue(true) &&
      job.jobFreelancerId.value != null;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: jobsRef.doc(widget.jobId).snapshots(),
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
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(jobStatus()),
              CustomField(
                text: job.jobDescription.value,
                label: kNewJobDescription,
              ),
              CustomField(
                text: job.location.value?.toString(),
                label: kNewLocation,
              ),
              CustomField(
                text: job.dateRange.value,
                label: kNewDateRange,
              ),
              CustomField(
                text: job.price.value,
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
    if (job.isOwnerCompleted.value == true) return kOwnerCompleted;

    // job freelancer completed
    if (job.isFreelancerCompleted.value == true) return kFreelancerCompleted;

    // job freelancer dismissed
    if (job.jobFreelancerId.value != currentUser.uid.value &&
        job.jobOwnerId.value != currentUser.uid.value) return kFreelancerDismissed;

    // job on going
    if (job.jobState.value == "onGoing" && job.applications.value != null
        ? job.applications.value.containsValue(true)
        : false) return kJobOnGoing;

    //job has no freelancer
    if (job.jobState.value == "open" &&
        (job.applications.value != null
            ? job.applications.value.containsValue(true) == false
            : true) &&
        job.jobFreelancerId.value == null) return kHasNoJobFreelancer;

    // job closed
    if (job.jobState.value == "closed") return kJobCanceled;

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
              physics: BouncingScrollPhysics(),
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: buildNotifications(),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                  ),
                ),
                isJobOwner ? buildOwnerDrawer(context) : buildFreelancerDrawer(context),
              ],
            ),
          ),
          ListTile(
            title: Text(kFAQ),
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
        snapshot.data.docs.forEach((doc) {
          feedItems.add(ActivityFeedItem(feed: ActivityFeed.fromDocument(doc)));
        });
        return ListView(
          physics: BouncingScrollPhysics(),
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
                          buildDismissFreelancerDrawerItem(context),
                          buildContactTeamDrawerItem(context),
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
                  buildContactTeamDrawerItem(context),
                  buildDeletJobDrawerItem(context),
                ],
              );
  }

  ListTile buildContactTeamDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kContactTeam),
      onTap: () {
        showSignalAbuseScreen(context, job: job);
      },
    );
  }

  ListTile buildDeletJobDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kDeleteJob),
      onTap: () {
        if (hasJobFreelancer)
          buildShowDialog(context,
              title: kDismissFreelancerBeforeCancel,
              contentText: kDismissFreelancerBeforeCancelInstruction);
        else
          showDeleteJobScreen(context, job: job);
      },
    );
  }

  Future buildShowDialog(
    BuildContext context, {
    @required String title,
    @required String contentText,
  }) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(
              contentText,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        children: [
          FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                kOk,
                style: TextStyle(color: Colors.blue),
              ))
        ],
      ),
    );
  }

  ListTile buildChatDrawerItem(BuildContext context) {
    return ListTile(
      title: Text(kShowChat),
      onTap: () {
        if (hasJobFreelancer) {
          final String jobChatId = job.jobOwnerId.value + "&&" + job.jobFreelancerId.value;
          showMessages(
            context,
            jobChatId: jobChatId,
            jobId: job.jobId.value,
            professionalTitle: job.professionalTitle.value,
            jobTitle: job.jobTitle.value,
            jobOwnerId: job.jobOwnerId.value,
            jobOwnerName: job.jobOwnerName.value,
          );
        } else {
          buildShowDialog(context,
              title: kHasNoJobFreelancer, contentText: kHasNoJobFreelancerDialogInstruction);
        }
      },
    );
  }

  ListTile buildDismissFreelancerDrawerItem(BuildContext parentContext) {
    return ListTile(
      title: Text(isJobOwner ? kDismissCurrentFreelancerAndPostJobAgain : kFreelancerQuitJob),
      onTap: () {
        if (hasJobFreelancer) {
          showDialog(
              context: parentContext,
              builder: (context) {
                return SimpleDialog(
                  title: Text(kDismissCurrentFreelancerAndPostJobAgain),
                  children: <Widget>[
                    SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context);
                          showDismissFreelancerScreen(context, job: job);
                        },
                        child: Text(
                          kDismiss,
                          style: TextStyle(color: Colors.red),
                        )),
                    SimpleDialogOption(
                        onPressed: () => Navigator.pop(context), child: Text(kCancel)),
                  ],
                );
              });
        } else {
          buildShowDialog(context,
              title: kHasNoJobFreelancer, contentText: kHasNoJobFreelancerDialogInstruction);
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

  IconButton buildUpdateJobTermsDialogueIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.update,
        size: 50.0,
      ),
      color: Colors.blue,
      disabledColor: Colors.grey,
      onPressed: isJobOwner
          ? job.hasFreelancerUpdateRequest.value
              ? () {
                  showUpdateJobTermsDialogueScreen(context,
                      job: job,
                      newJobDescription: job.newJobDescription.value,
                      newPrice: job.newPrice.value,
                      newLocation: job.newLocation.value,
                      newDateRange: job.newDateRange.value);
                }
              : null
          : job.hasOwnerUpdateRequest.value
              ? () {
                  showUpdateJobTermsDialogueScreen(context,
                      job: job,
                      newJobDescription: job.newJobDescription.value,
                      newPrice: job.newPrice.value,
                      newLocation: job.newLocation.value,
                      newDateRange: job.newDateRange.value);
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
                  .difference(job.jobFreelancerEnrollmentDate.value.toDate())
                  .inHours >
              -1;
          if (isTimeValid) {
            showCompleteJobScreen(context, job: job);
          } else {
            buildShowDialog(context,
                title: kLessThan24Hours, contentText: kLessThan24HoursInstruction);
          }
        } else {
          buildShowDialog(context,
              title: kHasNoJobFreelancer, contentText: kHasNoJobFreelancerDialogInstruction);
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
          buildShowDialog(context,
              title: kHasUnresolvedUpdateRequest,
              contentText: kHasUnresolvedUpdateRequestInstruction);
        } else if (!hasJobFreelancer)
          buildShowDialog(context,
              title: kHasNoJobFreelancer, contentText: kHasNoJobFreelancerDialogInstruction);
      },
    );
  }

  getActivityFeed() {
    return activityFeedRef
        .doc(currentUser.uid.value)
        .collection('feedItems')
        .where("jobId", isEqualTo: job.jobId.value)
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
