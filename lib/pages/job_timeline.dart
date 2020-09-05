import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/upload_job.dart';
import 'package:khadamat/widgets/business_card.dart';
import 'package:khadamat/widgets/custom_button.dart';
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
  List<String> professionalCategoriesList;
  List<JobCard> professionalTitlesList;
  List<String> followingList = [];
  List<BusinessCard> cards = [];
  String professionalCategory;

  bool isLoading = false;

  String selectedTab;

  @override
  void initState() {
    super.initState();
    getCategoriesList();

//    getCardSuggestions();
  }

  getCategoriesList() async {
    QuerySnapshot snapshot = await categoriesRef.getDocuments();
    List<String> jobs =
        snapshot.documents.map((doc) => doc.documentID).toList();
    setState(() {
      this.professionalCategoriesList = jobs;
    });
  }

  getJobList() async {
    QuerySnapshot snapshot = await categoriesRef
        .document(professionalCategory)
        .collection("professionalTitles")
        .getDocuments();
    List<JobCard> jobs = snapshot.documents
        .map((doc) => JobCard(Job.fromDocument(doc)))
        .toList();
    setState(() {
      this.professionalTitlesList = jobs;
    });
  }

//  getCardSuggestions() async {
//    QuerySnapshot snapshot = await cardsRef
//        .where("hobTitle", isEqualTo: currentUser.professionalTitle)
//        .where("isVacant", isEqualTo: false)
//        .orderBy("timestamp", descending: true)
//        .getDocuments();
//    List<JobCard> jobs = snapshot.documents
//        .map((doc) => JobCard(Job.fromDocument(doc)))
//        .toList();
//    setState(() {
//      this.categoriesList = jobs;
//    });
//  }

  buildJobTimeline() {
    if (professionalCategoriesList == null) {
      return circularProgress();
    } else if (professionalCategoriesList.isEmpty) {
//      return buildUsersToFollow();
    } else {
      return buildCategoriesGrid();
    }
  }

  buildCardTimeline() {
    if (professionalCategoriesList == null) {
      return circularProgress();
    } else if (professionalCategoriesList.isEmpty) {
//      return buildUsersToFollow();
    } else {
      return ListView(children: cards);
    }
  }

//  buildUsersToFollow() {
//    return StreamBuilder(
//      stream:
//          usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) {
//          return circularProgress();
//        }
//        List<UserResult> userResults = [];
//        snapshot.data.documents.forEach((doc) {
//          User user = User.fromDocument(doc);
//          final bool isAuthUser = currentUser.id == user.id;
//          final bool isFollowingUser = followingList.contains(user.id);
//          // remove auth user from recommended list
//          if (isAuthUser) {
//            return;
//          } else if (isFollowingUser) {
//            return;
//          } else {
//            UserResult userResult = UserResult(user);
//            userResults.add(userResult);
//          }
//        });
//        return Container(
//          color: Theme.of(context).accentColor.withOpacity(0.2),
//          child: Column(
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(12.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Icon(
//                      Icons.person_add,
//                      color: Theme.of(context).primaryColor,
//                      size: 30.0,
//                    ),
//                    SizedBox(
//                      width: 8.0,
//                    ),
//                    Text(
//                      "Users to Follow",
//                      style: TextStyle(
//                        color: Theme.of(context).primaryColor,
//                        fontSize: 30.0,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              Column(children: userResults),
//            ],
//          ),
//        );
//      },
//    );
//  }
  buildCategoriesGrid() {
    if (isLoading) {
      return linearProgress();
    } else if (professionalCategoriesList.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/no_content.svg', height: 260.0),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "No Posts",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (true) {
      List<GridTile> gridTiles = [];
      professionalCategoriesList.forEach((category) {
        gridTiles.add(GridTile(child: Text(category)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    }
//    } else if (selectedTab == "list") {
//      return Column(
//        children: posts,
//      );
//    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, isAppTitle: true),
      body: RefreshIndicator(
        onRefresh: () => getCategoriesList(),
        child: buildJobTimeline(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showUploadJobPage(context, currentUser: currentUser),
        child: Icon(Icons.add),
      ),
    );
  }
}
