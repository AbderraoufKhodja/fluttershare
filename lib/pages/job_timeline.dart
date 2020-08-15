import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/search.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/job.dart';
import 'package:khadamat/widgets/progress.dart';

final usersRef = Firestore.instance.collection('users');

class JobTimeline extends StatefulWidget {
  final User currentUser;

  JobTimeline({this.currentUser});

  @override
  _JobTimelineState createState() => _JobTimelineState();
}

class _JobTimelineState extends State<JobTimeline> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Job> jobPosts;
  List<String> followingList = [];

  @override
  void initState() {
    super.initState();
    getJobTimeline();
    getFollowing();
  }

  getJobTimeline() async {
    QuerySnapshot snapshot = await jobPostsRef
        .document(widget.currentUser.id)
        .collection('userJobPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Job> jobPosts =
        snapshot.documents.map((doc) => Job.fromDocument(doc)).toList();
    setState(() {
      this.jobPosts = jobPosts;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(currentUser.id)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingList = snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  buildJobTimeline() {
    if (jobPosts == null) {
      return circularProgress();
    } else if (jobPosts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView(children: jobPosts);
    }
  }

  buildUsersToFollow() {
    return StreamBuilder(
      stream:
          usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> userResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          final bool isAuthUser = currentUser.id == user.id;
          final bool isFollowingUser = followingList.contains(user.id);
          // remove auth user from recommended list
          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Container(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Users to Follow",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: userResults),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.withOpacity(0.2),
        appBar: header(context, isAppTitle: true),
        body: RefreshIndicator(
            onRefresh: () => getJobTimeline(), child: buildJobTimeline()));
  }
}
