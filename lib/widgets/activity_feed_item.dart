import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/activity_feed.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/pages/manage_jobs_page.dart';
import 'package:khadamat/pages/messages.dart';
import 'package:khadamat/pages/profile.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget mediaPreview;
String activityItemText;
Function onTap;

class ActivityFeedItem extends StatelessWidget {
  final ActivityFeed feed;

  ActivityFeedItem({@required this.feed});

  bool get isJobOwner => feed.jobOwnerId.value == currentUser.uid.value;
  bool get isRequestOwner => feed.requestOwnerId.value == currentUser.uid.value;

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Container(
      color: Colors.white54,
      child: GestureDetector(
        onTap: onTap,
        child: TimelineTile(
          beforeLineStyle: LineStyle(color: Colors.green, thickness: 2),
          alignment: TimelineAlign.manual,
          lineXY: 0.2,
          indicatorStyle: IndicatorStyle(
            height: 40,
            width: 30,
            indicator: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: mediaPreview,
            ),
          ),
          startChild: Text(
            feed.createdAt.value != null
                ? timeago.format(feed.createdAt.value.toDate())
                : kAMomentAGo,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          endChild: ListTile(
            title: Text(
              feed.type.value,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: activityItemText,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  showJob(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageJobsPage(),
      ),
    );
  }

  configureMediaPreview(context) {
    // TODO correct the feed logic
    SnackBar snackbar = SnackBar(content: Text(kUnavailable));
    if (feed.type.value == "apply") {
      mediaPreview = Icon(
        Icons.person_add,
        color: Colors.blue,
      );
      onTap = () async {
        DocumentSnapshot doc = await jobsRef.doc(feed.jobId.value).get();
        if (doc.exists) {
          Job job = Job.fromDocument(doc);
          if (job.jobState.value == "open")
            showProfile(
              context,
              profileId: feed.applicantId.value,
              job: job,
            );
        } else
          Scaffold.of(context).showSnackBar(snackbar);
      };
      activityItemText = isJobOwner
          ? "${feed.applicantName.value} applied to your job"
          : "You have applied to ${feed.jobOwnerName.value}'s job";
    } else if (feed.type.value == "acceptApplication") {
      mediaPreview = Icon(
        Icons.check,
        color: Colors.green,
      );
      onTap = () {
        showManageJob(context, jobId: feed.jobId.value);
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "You have accepted ${feed.jobFreelancerName.value} application."
          : "${feed.jobOwnerName.value} accepted your application.";
    } else if (feed.type.value == "rejectApplication") {
      mediaPreview = Icon(
        Icons.clear,
        color: Colors.red,
      );
      onTap = () {
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "You have rejected ${feed.jobFreelancerName.value} application."
          : "${feed.jobOwnerName.value} rejected your application.";
    } else if (feed.type.value == "message") {
      mediaPreview = Icon(
        Icons.message,
        color: Colors.blue,
      );
      onTap = () {
        showMessages(
          context,
          jobChatId: feed.jobChatId.value,
          jobId: feed.jobId.value,
          professionalTitle: feed.professionalTitle.value,
          jobTitle: feed.jobTitle.value,
          jobOwnerName: feed.jobOwnerName.value,
          jobOwnerId: feed.jobOwnerId.value,
        );
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "$kNewMessage ${feed.jobFreelancerName.value}"
          : "$kNewMessage ${feed.jobOwnerName.value}";
    } else if (feed.type.value == "hire") {
      mediaPreview = Icon(Icons.add, color: Colors.teal);
      onTap = () {
        markAsRead();
      };
      activityItemText = '${feed.jobOwnerName.value} $kHireNotification';
    } else if (feed.type.value == "open") {
      mediaPreview = Icon(
        Icons.chat,
        color: Colors.teal,
      );
      onTap = () {
        showMessages(
          context,
          jobChatId: feed.jobChatId.value,
          jobId: feed.jobId.value,
          professionalTitle: feed.professionalTitle.value,
          jobTitle: feed.jobTitle.value,
          jobOwnerId: feed.jobOwnerId.value,
          jobOwnerName: feed.jobOwnerName.value,
        );
        markAsRead();
      };
      activityItemText = isJobOwner
          ? '$kOpenChat ${feed.jobFreelancerName.value}'
          : '$kOpenChat ${feed.jobOwnerName.value}';
    } else if (feed.type.value == 'updateTerms') {
      mediaPreview = Icon(Icons.update, color: Colors.red);
      onTap = () {
        showManageJob(context, jobId: feed.jobId.value);
        markAsRead();
      };

      activityItemText = isRequestOwner
          ? "$kUpdateRequested"
          : "$kUpdateRequestFrom ${feed.requestOwnerName.value}.";
    } else if (feed.type.value == 'completeJob') {
      mediaPreview = Icon(
        Icons.thumb_up,
        color: Colors.green,
      );
      onTap = () {
        // TODO: Complete job point to review
        markAsRead();
      };
      activityItemText = isRequestOwner
          ? "$kUpdateRequested"
          : "$kUpdateRequestFrom ${feed.requestOwnerName.value}.";
    } else if (feed.type.value == 'dismissFreelancer') {
      mediaPreview = Icon(
        Icons.thumb_down,
        color: Colors.red,
      );
      onTap = () {
        // TODO: Complete job point to review
        markAsRead();
      };
      activityItemText = isRequestOwner
          ? "$kUpdateRequested"
          : "$kUpdateRequestFrom ${feed.requestOwnerName.value}.";
    } else {
      mediaPreview = Text('');
      activityItemText = "Error: Unknown type '${feed.type.value}'";
      onTap = () {
        markAsRead();
      };
    }
  }

  Future<void> markAsRead() => feed.feedReference.value.update({"read": true});
}
