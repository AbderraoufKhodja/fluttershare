import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/profile.dart';
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
    Future<QuerySnapshot> users = usersRef
        .where("googleName", isGreaterThanOrEqualTo: query)
        .getDocuments();
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
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<FreelancerCard> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          FreelancerCard searchResult = FreelancerCard(user);
          searchResults.add(searchResult);
        });
        return ListView(
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

class FreelancerCard extends StatelessWidget {
  final User user;

  FreelancerCard(this.user);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showProfile(
        context,
        profileId: user.id,
        profileName: user.username,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                    image: CachedNetworkImageProvider(
                        user.photoUrl ?? kBlankProfileUrl),
                  ),
                ),
              ),
              Container(
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.white, Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(user.reviews['rating']?.toString() ??
                                kMissingData),
                            Icon(
                              Icons.star,
                              color: Colors.amber[600],
                              size: 15,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              user.username ?? kMissingData,
                              style: TextStyle(
                                fontFamily: "ReemKufi-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 3),
                              color: Colors.black,
                              width: 100,
                              height: 1,
                            ),
                            Text(
                              user.professionalTitle?.toUpperCase() ??
                                  kMissingData,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
