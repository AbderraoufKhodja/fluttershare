import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/activity_feed.dart';
import 'package:khadamat/pages/comments.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/job_screen.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_image.dart';
import 'package:khadamat/widgets/custom_list_tile.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobCard extends StatefulWidget {
  final Job job;
  JobCard(this.job);

  @override
  _JobCardState createState() => _JobCardState(job: this.job);
}

class _JobCardState extends State<JobCard> {
  final Job job;

  _JobCardState({this.job});

  final String currentUserId = currentUser?.id;
  bool isLoading;
  bool isApplied;
  int applicationsCount;
  @override
  void initState() {
    super.initState();
    applicationsCount = job.getApplicationsCount();
  }

  @override
  Widget build(BuildContext context) {
    isApplied = (job.applications[currentUserId] == true);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildJobHeader(),
          buildJobContent(),
          buildJobFooter(),
        ],
      ),
    );
  }

  // Note: To delete job, ownerId and currentUserId must be equal, so they can be used interchangeably
  handleDeleteJob(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this job?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    job.deleteJob();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  buildJobHeader() {
    bool isJobOwner = currentUserId == job.ownerId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(job.mediaUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: job.ownerId),
            child: Text(
              job.username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(timeago.format(job.timestamp.toDate())),
          trailing: Column(
            children: [
              Text(applicationsCount.toString()),
              isJobOwner
                  ? IconButton(
                      onPressed: () => handleDeleteJob(context),
                      icon: Icon(Icons.more_vert),
                    )
                  : IconButton(
                      onPressed: () => print("job applied (saved)"),
                      icon: isApplied
                          ? Icon(Icons.bookmark_border)
                          : Icon(Icons.bookmark),
                    ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 5.0, left: 5.0)),
      ],
    );
  }

  buildJobContent() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomListTile(
                  description: job.jobCategory,
                  icon: Icon(
                    Icons.work,
                    color: Colors.blueGrey,
                  ),
                ),
                CustomListTile(
                  description: job.description,
                  icon: Icon(
                    Icons.description,
                    color: Colors.blueGrey,
                  ),
                  maxLines: 2,
                ),
                CustomListTile(
                  description: job.location,
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.blueGrey,
                  ),
                ),
                CustomListTile(
                  description: job.schedule,
                  icon: Icon(
                    Icons.schedule,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.black,
          ),
          job.mediaUrl.isEmpty
              ? Text("")
              : Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: cachedNetworkImage(job.mediaUrl),
                ),
        ],
      ),
    );
  }

  buildJobFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
//        Expanded(
//          child: CustomButton(
//            text: "Message",
//            function: () => print("Message"),
//          ),
//        ),
        Expanded(
          child: CustomButton(
            text: "Details",
            function: showDetails,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 10.0),
            child: Text(
              "${job.price} DA",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

logConsoleFirebase() async {
//  QuerySnapshot snapshot = await jobsRef.where("userJobs",isGreaterThanOrEqualTo: ).getDocuments();
//  List<JobCard> jobs =
//      snapshot.documents.map((doc) => JobCard(Job.fromDocument(doc))).toList();
//  print(snapshot.documents.first.data);
}
showDetails(BuildContext context,
// TODO: fix this
    {String jobId,
    String ownerId,
    String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return JobScreen(
//      job: job,
        );
  }));
}
