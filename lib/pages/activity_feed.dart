import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/pages/manage_jobs_screen.dart';
import 'package:khadamat/pages/messages.dart';
import 'package:khadamat/pages/profile.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeline_tile/timeline_tile.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        body: Container(
          child: StreamBuilder(
            stream: getActivityFeed(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              if (snapshot.data == null) {
                return Center(child: Text(kEmpty));
              }
              List<ActivityFeedItem> feedItems = [];
              snapshot.data.docs.forEach((doc) {
                feedItems.add(ActivityFeedItem.fromDocument(doc));
              });
              return ListView(
                physics: BouncingScrollPhysics(),
                children: feedItems,
              );
            },
          ),
        ),
      ),
    );
  }

  getActivityFeed() {
    return activityFeedRef
        .doc(currentUser.uid)
        .collection('feedItems')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots();
  }

  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}

Widget mediaPreview;
String activityItemText;
Function onTap;

class ActivityFeedItem extends StatelessWidget {
  final String type; // 'apply', 'accept', 'reject', 'hire', 'message'
  final String jobId;
  final String jobChatId;
  final String professionalTitle;
  final String jobTitle;
  final String jobOwnerName;
  final String jobOwnerId;
  final String jobFreelancerName;
  final String jobFreelancerId;
  final String applicantName;
  final String applicantId;
  final String requestOwnerId;
  final String requestOwnerName;
  final String newPrice;
  final String newLocation;
  final String newDateRange;
  final String userProfileImg;
  final String commentData;
  final Timestamp createdAt;
  final DocumentReference feedReference;

  ActivityFeedItem({
    this.type,
    this.jobId,
    this.professionalTitle,
    this.jobTitle,
    this.jobOwnerName,
    this.jobOwnerId,
    this.jobFreelancerName,
    this.jobFreelancerId,
    this.applicantName,
    this.applicantId,
    this.requestOwnerName,
    this.requestOwnerId,
    this.newPrice,
    this.newLocation,
    this.newDateRange,
    this.userProfileImg,
    this.commentData,
    this.createdAt,
    this.feedReference,
    this.jobChatId,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
        type: fieldGetter(document: doc, field: 'type'),
        jobId: fieldGetter(document: doc, field: 'jobId'),
        jobChatId: fieldGetter(document: doc, field: 'jobChatId'),
        professionalTitle:
            fieldGetter(document: doc, field: 'professionalTitle'),
        jobTitle: fieldGetter(document: doc, field: 'jobTitle'),
        jobOwnerName: fieldGetter(document: doc, field: 'jobOwnerName'),
        jobOwnerId: fieldGetter(document: doc, field: 'jobOwnerId'),
        jobFreelancerName:
            fieldGetter(document: doc, field: 'jobFreelancerName'),
        jobFreelancerId: fieldGetter(document: doc, field: 'jobFreelancerId'),
        applicantName: fieldGetter(document: doc, field: 'applicantName'),
        applicantId: fieldGetter(document: doc, field: 'applicantId'),
        requestOwnerName: fieldGetter(document: doc, field: 'requestOwnerName'),
        requestOwnerId: fieldGetter(document: doc, field: 'requestOwnerId'),
        newPrice: fieldGetter(document: doc, field: 'newPrice'),
        newLocation: fieldGetter(document: doc, field: 'newLocation'),
        newDateRange: fieldGetter(document: doc, field: 'newDateRange'),
        userProfileImg: fieldGetter(document: doc, field: 'userProfileImg'),
        createdAt: fieldGetter(document: doc, field: 'createdAt'),
        feedReference: fieldGetter(
          document: doc,
          field: doc.reference.id,
        ));
  }

  bool get isJobOwner => currentUser.uid == jobOwnerId;

  showJob(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageJobsScreen(),
      ),
    );
  }

  configureMediaPreview(context) {
    // TODO correct the feed logic
    SnackBar snackbar = SnackBar(content: Text(kUnavailable));
    if (type == "apply") {
      mediaPreview = Icon(
        Icons.person_add,
        color: Colors.blue,
      );
      onTap = () async {
        DocumentSnapshot doc = await jobsRef.doc(jobId).get();
        if (doc.exists) {
          Job job = Job.fromDocument(doc);
          if (job.jobState == "open")
            showProfile(
              context,
              profileId: applicantId,
              profileName: applicantName,
              job: job,
            );
        } else
          Scaffold.of(context).showSnackBar(snackbar);
      };
      activityItemText = isJobOwner
          ? "$applicantName applied to your job"
          : "You have applied to $jobOwnerName's job";
    } else if (type == "acceptApplication") {
      mediaPreview = Icon(
        Icons.check,
        color: Colors.green,
      );
      onTap = () {
        showManageJob(context, jobId: jobId);
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "You have accepted $jobFreelancerName application."
          : "$jobOwnerName accepted your application.";
    } else if (type == "rejectApplication") {
      mediaPreview = Icon(
        Icons.clear,
        color: Colors.red,
      );
      onTap = () {
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "You have rejected $jobFreelancerName application."
          : "$jobOwnerName rejected your application.";
    } else if (type == "message") {
      mediaPreview = Icon(
        Icons.message,
        color: Colors.blue,
      );
      onTap = () {
        showMessages(
          context,
          jobChatId: jobChatId,
          jobId: jobId,
          professionalTitle: professionalTitle,
          jobTitle: jobTitle,
          jobOwnerName: jobOwnerName,
          jobOwnerId: jobOwnerId,
        );
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "$kNewMessage $jobFreelancerName"
          : "$kNewMessage $jobOwnerName";
    } else if (type == "hire") {
      mediaPreview = Icon(Icons.add, color: Colors.teal);
      onTap = () {
        markAsRead();
      };
      activityItemText = '$jobOwnerName $kHireNotification';
    } else if (type == "open") {
      mediaPreview = Icon(
        Icons.chat,
        color: Colors.teal,
      );
      onTap = () {
        showMessages(
          context,
          jobChatId: jobChatId,
          jobId: jobId,
          professionalTitle: professionalTitle,
          jobTitle: jobTitle,
          jobOwnerId: jobOwnerId,
          jobOwnerName: jobOwnerName,
        );
        markAsRead();
      };
      activityItemText = isJobOwner
          ? '$kOpenChat $jobFreelancerName'
          : '$kOpenChat $jobOwnerName';
    } else if (type == 'updateTerms') {
      mediaPreview = Icon(Icons.update, color: Colors.red);
      onTap = () {
        showManageJob(context, jobId: jobId);
        markAsRead();
      };

      activityItemText = isRequestOwner
          ? "$kUpdateRequested"
          : "$kUpdateRequestFrom $requestOwnerName.";
    } else if (type == 'completeJob') {
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
          : "$kUpdateRequestFrom $requestOwnerName.";
    } else if (type == 'dismissFreelancer') {
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
          : "$kUpdateRequestFrom $requestOwnerName.";
    } else {
      mediaPreview = Text('');
      activityItemText = "Error: Unknown type '$type'";
      onTap = () {
        markAsRead();
      };
    }
  }

  Future<void> markAsRead() => feedReference.update({"read": true});

  bool get isRequestOwner => requestOwnerId == currentUser.uid;

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
            createdAt != null
                ? timeago.format(createdAt.toDate())
                : kAMomentAGo,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          endChild: ListTile(
            title: Text(
              type,
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
}
