import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/items_horizontal_view.dart';

class TrendingFreelancersPage extends StatefulWidget {
  @override
  _TrendingFreelancersPage createState() => _TrendingFreelancersPage();
}

class _TrendingFreelancersPage extends State<TrendingFreelancersPage> {
  Future<QuerySnapshot> searchResultsFuture;
  List<String> popularCategories = ["Developper"];
  final geo = GeoFlutterFire();

  @override
  void initState() {
    super.initState();
    getPopularCategories();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 20, top: 20),
      children: [
        ItemsHorizontalView(
          title: kTrendingTopRatedSection,
          futureItems: getTrendingTopRatedSection(),
        ),
        // ItemsHorizontalView(
        //     title: kTrendingExperiencedSection,
        //     futureItems: getTrendingMostExperiencedSection()),
        // ItemsHorizontalView(
        //   title: kTrendingHighestCompletionRateSection,
        //   futureItems: getTrendingHighestCompletionRateSection(),
        // ),
        // ItemsHorizontalView(
        //   title: kTrendingPopularAdvisorsSection,
        //   futureItems: getTrendingPopularAdvisorsSection(),
        // ),
        // ItemsHorizontalView(
        //   title: kTrendingHighQualityFreelancersSection,
        //   futureItems: getTrendingHighQualityFreelancersSection(),
        // ),
        // ItemsHorizontalView(
        //   title: kTrendingTopTeamChoiceFreelancersSection,
        //   futureItems: getTrendingTopTeamChoiceFreelancersSection(),
        // ),
        // ItemsHorizontalView(
        //   title: kTrendingTopFreelancersAroundMeSection,
        //   futureItems: getTrendingTopFreelancersAroundMeSection(),
        // ),
      ],
    );
  }

  Future<QuerySnapshot> getTrendingTopRatedSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .where("globalRate", whereNotIn: [4.0, 5])
        .orderBy("createdAt", descending: true)
        .limit(30)
        .get();
  }

  Future<QuerySnapshot> getTrendingMostExperiencedSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .where("experienceRate", isGreaterThanOrEqualTo: 4.0)
        .orderBy("createdAt", descending: true)
        .limit(30)
        .get();
  }

  Future<QuerySnapshot> getTrendingHighestCompletionRateSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .where("completionRate", isGreaterThanOrEqualTo: 4.0)
        .orderBy("createdAt", descending: true)
        .limit(30)
        .get();
  }

  Future<QuerySnapshot> getTrendingPopularAdvisorsSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .where("popularityRate", isGreaterThanOrEqualTo: 4.0)
        .orderBy("createdAt", descending: true)
        .limit(30)
        .get();
  }

  Future<List<DocumentSnapshot>> getTrendingTopFreelancersAroundMeSection() {
    // TODO  sorting dcuments according to newest.
    GeoPoint usersLocation = currentUser.location.value.geoFiredata["geopoint"];
    GeoFirePoint center = geo.point(
        latitude: usersLocation.latitude, longitude: usersLocation.longitude);

    double radius = 50;
    String field = 'location';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(
            collectionRef: usersRef
                .where("isFreelancer", isEqualTo: true)
                .where("professionalCategory", whereIn: popularCategories))
        .within(center: center, radius: radius, field: field);

    return stream.first;
  }

  Future<QuerySnapshot> getTrendingTopTeamChoiceFreelancersSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .where("teamChoice", isEqualTo: true)
        .orderBy("createdAt", descending: true)
        .limit(30)
        .get();
  }

  Future<QuerySnapshot> getTrendingHighQualityFreelancersSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .where("qualityRating", isGreaterThanOrEqualTo: 4.0)
        .orderBy("createdAt", descending: true)
        .limit(10)
        .get();
  }

  Future<void> getPopularCategories() async {
    QuerySnapshot snap = await popularCategoriesRef.get();
    setState(() {
      popularCategories = snap.docs.map((doc) => doc.id).toList();
      print(popularCategories);
    });
  }
}
