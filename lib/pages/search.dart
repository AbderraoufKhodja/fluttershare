import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/freelancer_card.dart';
import 'package:khadamat/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>
    with AutomaticKeepAliveClientMixin<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("displayName", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  // AppBar buildSearchField() {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     title: TextFormField(
  //       controller: searchController,
  //       decoration: InputDecoration(
  //         hintText: "Search for a user...",
  //         filled: true,
  //         prefixIcon: Icon(
  //           Icons.account_box,
  //           size: 28.0,
  //         ),
  //         suffixIcon: IconButton(
  //           icon: Icon(Icons.clear),
  //           onPressed: clearSearch,
  //         ),
  //       ),
  //       onFieldSubmitted: handleSearch,
  //     ),
  //   );
  // }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Text(
              "Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<FreelancerCard> searchResults = [];
        snapshot.data.docs.forEach((doc) {
          AppUser user = AppUser.fromDocument(doc);
          FreelancerCard searchResult = FreelancerCard(user);
          searchResults.add(searchResult);
        });
        return ListView(
          physics: BouncingScrollPhysics(),
          children: searchResults,
        );
      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}
