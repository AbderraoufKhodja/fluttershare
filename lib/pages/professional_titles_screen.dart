import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:khadamat/widgets/title_button.dart';

class ProfessionalTitlesScreen extends StatefulWidget {
  final String professionalTitle;

  ProfessionalTitlesScreen({@required this.professionalTitle});

  @override
  _ProfessionalTitlesScreenState createState() => _ProfessionalTitlesScreenState();
}

class _ProfessionalTitlesScreenState extends State<ProfessionalTitlesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> professionalTitlesList;
  List<String> followingList = [];

  bool isLoading = false;

  String selectedTab;

  @override
  void initState() {
    super.initState();
    getProfessionalTitlesList();
  }

  getProfessionalTitlesList() async {
    QuerySnapshot snapshot =
        await categoriesRef.doc(widget.professionalTitle).collection("professionalTitles").get();
    List<String> professionalTitle = snapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      professionalTitlesList = professionalTitle;
    });
  }

  buildProfessionalTitlesGrid() {
    if (professionalTitlesList == null) {
      return circularProgress();
    } else if (professionalTitlesList.isEmpty) {
      return Center(
        child: Icon(
          Icons.move_to_inbox,
          size: 160.0,
        ),
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
//        snapshot.data.docs.forEach((doc) {
//          User user = User.fromDocument(doc);
//          final bool isAuthUser = currentUser.uid == user.uid;
//          final bool isFollowingUser = followingList.contains(user.uid);
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
    } else if (professionalTitlesList.isEmpty) {
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
      professionalTitlesList.forEach((professionalTitle) {
        gridTiles.add(GridTile(child: TitleButton(professionalTitle: professionalTitle)));
      });
      return ListView(
        physics: BouncingScrollPhysics(),
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
      // appBar: header(context, isAppTitle: true),
      body: RefreshIndicator(
        onRefresh: () => getProfessionalTitlesList(),
        child: buildProfessionalTitlesGrid(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => showUploadJobScreen(context, currentUser: currentUser),
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

showProfessionalTitlesScreen(BuildContext context, {String category}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfessionalTitlesScreen(
          professionalTitle: category,
        ),
      ));
}
