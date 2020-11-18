import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/upload_job.dart';
import 'package:khadamat/widgets/category_button.dart';
import 'package:khadamat/widgets/header.dart';
import 'package:khadamat/widgets/progress.dart';

class ProfessionalCategoriesScreen extends StatefulWidget {
  ProfessionalCategoriesScreen();

  @override
  _ProfessionalCategoriesScreenState createState() =>
      _ProfessionalCategoriesScreenState();
}

class _ProfessionalCategoriesScreenState
    extends State<ProfessionalCategoriesScreen>
    with AutomaticKeepAliveClientMixin<ProfessionalCategoriesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> professionalCategoriesList;
  List<String> followingList = [];
  String professionalCategory;
  bool isLoading = false;
  String selectedTab;

  @override
  void initState() {
    super.initState();
    getProfessionalCategoriesList();
  }

  getProfessionalCategoriesList() async {
    QuerySnapshot snapshot = await categoriesRef.getDocuments();
    List<String> jobs =
        snapshot.documents.map((doc) => doc.documentID).toList();
    setState(() {
      this.professionalCategoriesList = jobs;
    });
  }

//  getCardSuggestions() async {
//    QuerySnapshot snapshot = await cardsRef
//        .where("hobTitle", isEqualTo: currentUser.professionalTitle)
//        .where("isVacant", isEqualTo: false)
//        .orderBy("createdAt", descending: true)
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
      return Center(
        child: Icon(Icons.move_to_inbox, size: 160.0),
      );
    } else {
      return buildCategoriesGrid();
    }
  }

//  buildUsersToFollow() {
//    return StreamBuilder(
//      stream:
//          usersRef.orderBy('createdAt', descending: true).limit(30).snapshots(),
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
    } else {
      List<GridTile> gridTiles = [];
      professionalCategoriesList.forEach((category) {
        gridTiles.add(
            GridTile(child: CategoryButton(professionalCategory: category)));
      });
      return ListView(
        children: [
          GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.5,
            crossAxisSpacing: 1.5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: gridTiles,
          ),
        ],
      );
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(
        context,
        isAppTitle: false,
        titleText: kSearch,
        hasAction: true,
        actionsList: {"more": () => print("more")},
      ),
      body: RefreshIndicator(
        onRefresh: () => getProfessionalCategoriesList(),
        child: buildJobTimeline(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showUploadJobScreen(context, currentUser: currentUser),
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
