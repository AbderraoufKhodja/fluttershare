import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/job_screen.dart';
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
//      print('Activity Feed Item: ${doc.data}');
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: header(context, titleText: "Activity Feed"),
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
  final String ownerName;
  final String applicantId;
  final String ownerId;
  final String type; // 'apply', 'accept', 'reject', 'hire', 'message'
  final String mediaUrl;
  final String jobId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem(
      {this.ownerName,
      this.ownerId,
      this.type,
      this.mediaUrl,
      this.jobId,
      this.userProfileImg,
      this.commentData,
      this.timestamp,
      this.applicantId});

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      ownerName: doc['ownerName'],
      applicantId: doc['applicantId'],
      ownerId: doc['ownerId'],
      type: doc['type'],
      jobId: doc['jobId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
    );
  }

  bool get isJobOwner => currentUser.id == ownerId;

  showJob(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobScreen(
          //TODO feed parameters
          job: null,
          userId: ownerId,
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
                  image: CachedNetworkImageProvider(mediaUrl),
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
          ? "$applicantId applied to your job"
          : "You have applied to $ownerName's job";
    } else if (type == 'accept') {
      activityItemText = isJobOwner
          ? "You have accepted $applicantId application for job $jobId"
          : "$ownerName accepted your application for job $jobId";
    } else if (type == 'comment') {
      activityItemText = 'replied: $commentData';
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
          leading: GestureDetector(
            onTap: () {
              Job job;
              jobsRef
                  .document(jobId)
                  .get()
                  .then((doc) => job = Job.fromDocument(doc));
              showProfile(context, profileId: ownerId, job: job);
            },
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfileImg),
            ),
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
                    text: isJobOwner ? "" : ownerName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' $activityItemText',
                  ),
                ]),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
