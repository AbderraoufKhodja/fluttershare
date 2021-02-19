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

  bool get isJobOwner => feed.jobOwnerId == currentUser.uid;
  bool get isRequestOwner => feed.requestOwnerId == currentUser.uid;

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
            feed.createdAt != null
                ? timeago.format(feed.createdAt.toDate())
                : kAMomentAGo,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          endChild: ListTile(
            title: Text(
              feed.type,
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
    if (feed.type == "apply") {
      mediaPreview = Icon(
        Icons.person_add,
        color: Colors.blue,
      );
      onTap = () async {
        DocumentSnapshot doc = await jobsRef.doc(feed.jobId).get();
        if (doc.exists) {
          Job job = Job.fromDocument(doc);
          if (job.jobState == "open")
            showProfile(
              context,
              profileId: feed.applicantId,
              profileName: feed.applicantName,
              job: job,
            );
        } else
          Scaffold.of(context).showSnackBar(snackbar);
      };
      activityItemText = isJobOwner
          ? "${feed.applicantName} applied to your job"
          : "You have applied to ${feed.jobOwnerName}'s job";
    } else if (feed.type == "acceptApplication") {
      mediaPreview = Icon(
        Icons.check,
        color: Colors.green,
      );
      onTap = () {
        showManageJob(context, jobId: feed.jobId);
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "You have accepted ${feed.jobFreelancerName} application."
          : "${feed.jobOwnerName} accepted your application.";
    } else if (feed.type == "rejectApplication") {
      mediaPreview = Icon(
        Icons.clear,
        color: Colors.red,
      );
      onTap = () {
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "You have rejected ${feed.jobFreelancerName} application."
          : "${feed.jobOwnerName} rejected your application.";
    } else if (feed.type == "message") {
      mediaPreview = Icon(
        Icons.message,
        color: Colors.blue,
      );
      onTap = () {
        showMessages(
          context,
          jobChatId: feed.jobChatId,
          jobId: feed.jobId,
          professionalTitle: feed.professionalTitle,
          jobTitle: feed.jobTitle,
          jobOwnerName: feed.jobOwnerName,
          jobOwnerId: feed.jobOwnerId,
        );
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "$kNewMessage ${feed.jobFreelancerName}"
          : "$kNewMessage ${feed.jobOwnerName}";
    } else if (feed.type == "hire") {
      mediaPreview = Icon(Icons.add, color: Colors.teal);
      onTap = () {
        markAsRead();
      };
      activityItemText = '${feed.jobOwnerName} $kHireNotification';
    } else if (feed.type == "open") {
      mediaPreview = Icon(
        Icons.chat,
        color: Colors.teal,
      );
      onTap = () {
        showMessages(
          context,
          jobChatId: feed.jobChatId,
          jobId: feed.jobId,
          professionalTitle: feed.professionalTitle,
          jobTitle: feed.jobTitle,
          jobOwnerId: feed.jobOwnerId,
          jobOwnerName: feed.jobOwnerName,
        );
        markAsRead();
      };
      activityItemText = isJobOwner
          ? '$kOpenChat ${feed.jobFreelancerName}'
          : '$kOpenChat ${feed.jobOwnerName}';
    } else if (feed.type == 'updateTerms') {
      mediaPreview = Icon(Icons.update, color: Colors.red);
      onTap = () {
        showManageJob(context, jobId: feed.jobId);
        markAsRead();
      };

      activityItemText = isRequestOwner
          ? "$kUpdateRequested"
          : "$kUpdateRequestFrom ${feed.requestOwnerName}.";
    } else if (feed.type == 'completeJob') {
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
          : "$kUpdateRequestFrom ${feed.requestOwnerName}.";
    } else if (feed.type == 'dismissFreelancer') {
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
          : "$kUpdateRequestFrom ${feed.requestOwnerName}.";
    } else {
      mediaPreview = Text('');
      activityItemText = "Error: Unknown type '${feed.type}'";
      onTap = () {
        markAsRead();
      };
    }
  }

  Future<void> markAsRead() => feed.feedReference.update({"read": true});
}
