import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/job_screen.dart';
import 'package:khadamat/pages/message_screen.dart';
import 'package:khadamat/pages/profile.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobActivityFeed extends StatefulWidget {
  @override
  _JobActivityFeedState createState() => _JobActivityFeedState();
}

class _JobActivityFeedState extends State<JobActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(30)
        .getDocuments();
    List<ActivityFeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: header(context,
          titleText: "Activity Feed",
          hasAction: true,
          actionLabel: "messages",
          action: () => showMessageScreen(context)),
      body: Container(
          child: FutureBuilder(
        future: getActivityFeed(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return ListView(
            children: snapshot.data,
          );
        },
      )),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String type; // 'apply', 'accept', 'reject', 'hire', 'message'
  final String jobId;
  final String jobTitle;
  final String jobOwnerName;
  final String jobOwnerId;
  final String applicantName;
  final String applicantId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem({
    this.type,
    this.jobId,
    this.jobTitle,
    this.jobOwnerName,
    this.jobOwnerId,
    this.applicantName,
    this.applicantId,
    this.userProfileImg,
    this.commentData,
    this.timestamp,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      type: doc['type'],
      jobId: doc['jobId'],
      jobTitle: doc['jobTitle'],
      jobOwnerName: doc['jobOwnerName'],
      jobOwnerId: doc['jobOwnerId'],
      applicantName: doc['applicantName'],
      applicantId: doc['applicantId'],
      userProfileImg: doc['userProfileImg'],
      timestamp: doc['timestamp'],
    );
  }

  bool get isJobOwner => currentUser.id == jobOwnerId;

  showJob(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobScreen(
          //TODO feed parameters
          job: null,
          userId: jobOwnerId,
        ),
      ),
    );
  }

  configureMediaPreview(context) {
    if (type == "apply" || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showJob(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(kBlankProfileUrl),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'apply') {
      activityItemText = isJobOwner
          ? "$applicantName applied to your job"
          : "You have applied to $jobOwnerName's job";
    } else if (type == 'accept') {
      activityItemText = isJobOwner
          ? "You have accepted $applicantId application for job $jobId"
          : "$jobOwnerName accepted your application for job $jobId";
    } else if (type == 'comment') {
      activityItemText = 'replied: $commentData';
    } else if (type == 'message') {
      activityItemText = "You have a new message from $jobTitle";
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          dense: true,
          leading: GestureDetector(
            onTap: () async {
              Job job;
              await jobsRef
                  .document(jobId)
                  .get()
                  .then((doc) => job = Job.fromDocument(doc));
              print("applicantId: $applicantId");
              print("applicantName: $applicantName");
              print("${job.applications}");
              showProfile(context,
                  profileId: applicantId, profileName: applicantName, job: job);
            },
            child: Text(type,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )),
          ),
          title: RichText(
            overflow: TextOverflow.ellipsis,
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
          subtitle: Text(
            timestamp != null
                ? timeago.format(timestamp.toDate())
                : "a moment ago",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
