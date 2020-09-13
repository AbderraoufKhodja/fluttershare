import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/pages/manage_jobs_screen.dart';
import 'package:khadamat/pages/messages.dart';
import 'package:khadamat/pages/messages_screen.dart';
import 'package:khadamat/widgets/job_card.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: IconButton(
              onPressed: () => showManageJobsScreen(context),
              icon: Icon(
                Icons.card_travel,
                size: 40.0,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () => showMessagesScreen(context),
              icon: Icon(
                Icons.message,
                size: 40.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
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
        ),
      ),
    );
  }

  getActivityFeed() {
    return activityFeedRef
        .document(currentUser.id)
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
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      type: doc['type'],
      jobId: doc['jobId'],
      professionalTitle: doc['professionalTitle'],
      jobTitle: doc['jobTitle'],
      jobOwnerName: doc['jobOwnerName'],
      jobOwnerId: doc['jobOwnerId'],
      jobFreelancerName: doc['jobFreelancerName'],
      jobFreelancerId: doc['jobFreelancerId'],
      applicantName: doc['applicantName'],
      applicantId: doc['applicantId'],
      requestOwnerName: doc['requestOwnerName'],
      requestOwnerId: doc['requestOwnerId'],
      newPrice: doc['newPrice'],
      newLocation: doc['newLocation'],
      newDateRange: doc['newDateRange'],
      userProfileImg: doc['userProfileImg'],
      createdAt: doc['createdAt'],
      feedReference: doc.reference,
    );
  }

  bool get isJobOwner => currentUser.id == jobOwnerId;

  showJob(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageJobsScreen(),
      ),
    );
  }

  configureMediaPreview(context) {
    SnackBar snackbar = SnackBar(content: Text(kUnavailable));
    if (type == "apply") {
      mediaPreview = Icon(Icons.mail, color: Colors.blue);
      onTap = () async {
        DocumentSnapshot doc = await jobsRef.document(jobId).get();
        if (doc.exists) {
          Job job = Job.fromDocument(doc);
          if (job.isVacant) showJobCard(context, job: job);
        } else
          Scaffold.of(context).showSnackBar(snackbar);
      };
      activityItemText = isJobOwner
          ? "$jobFreelancerName applied to your job"
          : "You have applied to $jobOwnerName's job";
    } else if (type == "acceptApplication") {
      mediaPreview = Icon(Icons.check, color: Colors.green);
      onTap = () {
        showManageJob(context, jobId: jobId);
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "You have accepted $jobFreelancerName application."
          : "$jobOwnerName accepted your application.";
    } else if (type == "rejectApplication") {
      mediaPreview = Icon(Icons.clear, color: Colors.red);
      onTap = () {
        markAsRead();
      };
      activityItemText = isJobOwner
          ? "You have rejected $jobFreelancerName application."
          : "$jobOwnerName rejected your application.";
    } else if (type == "message") {
      mediaPreview = Icon(Icons.message, color: Colors.blue);
      onTap = () {
        showMessages(
          context,
          jobId: jobId,
          professionalTitle: professionalTitle,
          jobTitle: jobTitle,
          jobFreelancerName: jobFreelancerName,
          jobFreelancerId: jobFreelancerId,
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
      mediaPreview = Icon(Icons.chat, color: Colors.teal);
      onTap = () {
        showMessages(context,
            jobId: jobId,
            professionalTitle: professionalTitle,
            jobTitle: jobTitle,
            jobOwnerId: jobOwnerId,
            jobOwnerName: jobOwnerName,
            jobFreelancerId: jobFreelancerId,
            jobFreelancerName: jobFreelancerName);
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
    } else {
      mediaPreview = Text('');
      activityItemText = "Error: Unknown type '$type'";
      onTap = () {
        markAsRead();
      };
    }
  }

  Future<void> markAsRead() => feedReference.updateData({"read": true});

  bool get isRequestOwner => requestOwnerId == currentUser.id;

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: GestureDetector(
          onTap: onTap,
          child: ListTile(
            leading: Text(type,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )),
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
              createdAt != null
                  ? timeago.format(createdAt.toDate())
                  : kAMomentAGo,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            trailing: mediaPreview,
          ),
        ),
      ),
    );
  }
}
