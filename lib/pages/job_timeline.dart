import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/search.dart';
import 'package:khadamat/widgets/business_card.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/job_card.dart';
import 'package:khadamat/widgets/progress.dart';

class JobTimeline extends StatefulWidget {
  final User currentUser;

  JobTimeline({this.currentUser});

  @override
  _JobTimelineState createState() => _JobTimelineState();
}

class _JobTimelineState extends State<JobTimeline> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<JobCard> jobs;
  List<String> followingList = [];

  List<BusinessCard> cards = [];

  @override
  void initState() {
    super.initState();
    getJobTimeline();
//    getCardSuggestions();
  }

  getJobTimeline() async {
    QuerySnapshot snapshot = await jobsRef
        .where("subCategory", isEqualTo: currentUser.subCategory)
        .where("isVacant", isEqualTo: true)
        .orderBy("timestamp", descending: true)
        .getDocuments();
    List<JobCard> jobs = snapshot.documents
        .map((doc) => JobCard(Job.fromDocument(doc)))
        .toList();
    setState(() {
      this.jobs = jobs;
    });
    print(this.jobs);
    print(currentUser.subCategory);
  }

  getCardSuggestions() async {
    QuerySnapshot snapshot = await cardsRef
        .where("subCategory", isEqualTo: currentUser.subCategory)
        .where("isVacant", isEqualTo: false)
        .orderBy("timestamp", descending: true)
        .getDocuments();
    List<JobCard> jobs = snapshot.documents
        .map((doc) => JobCard(Job.fromDocument(doc)))
        .toList();
    setState(() {
      this.jobs = jobs;
    });
  }

  buildJobTimeline() {
    if (jobs == null) {
      return circularProgress();
    } else if (jobs.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView(children: jobs);
    }
  }

  buildCardTimeline() {
    if (jobs == null) {
      return circularProgress();
    } else if (jobs.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView(children: cards);
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
          User user;
          if (doc['isFreelancer'] == true)
            user = User.freelancerFromDocument(doc);
          else
            user = User.clientFromDocument(doc);
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
        backgroundColor: Theme.of(context).primaryColor,
        appBar: header(context, isAppTitle: true),
        body: RefreshIndicator(
          onRefresh: () => getJobTimeline(),
          child: buildJobTimeline(),
        ));
  }
}
