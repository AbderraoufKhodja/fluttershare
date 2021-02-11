import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/items_horizontal_view.dart';

class FreelancerForYouPage extends StatefulWidget {
  final List<String> preferences;

  FreelancerForYouPage({this.preferences});
  @override
  _FreelancerForYouPage createState() => _FreelancerForYouPage();
}

class _FreelancerForYouPage extends State<FreelancerForYouPage> {
  Future<QuerySnapshot> searchResultsFuture;
  final geo = Geoflutterfire();
  List<String> preferences;
  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  void getPreferences() {
    if (widget.preferences != null)
      preferences = widget.preferences;
    else
      preferences = currentUser.preferences;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 20, top: 20),
      children: [
        ItemsHorizontalView(
          title: kRecommendedForYouSection,
          futureItems: getRecommendedForYouSection(),
        ),
        ItemsHorizontalView(
            title: kSuggestedForYouSection,
            futureItems: getSuggestedForYouSection()),
        ItemsHorizontalView(
          title: kRecentlyReviewdSection,
          futureItems: getRecentlyReviewdSection(),
        ),
        ItemsHorizontalView(
          title: kNewTalentsSection,
          futureItems: getNewTalentsSection(),
        ),
        ItemsHorizontalView(
          title: kTopFreelancerSection,
          futureItems: getTopFreelancerSection(),
        ),
        ItemsHorizontalView(
          title: kTeamChoiceFreelancers,
          futureItems: getTeamChoiceFreelancerSection(),
        ),
        ItemsHorizontalView(
          title: kBeTheFirstToHire,
          futureItems: getBeTheFirstToHireSection(),
        ),
        ItemsHorizontalView(
          title: kAroundMe,
          futureItems: getAroundMeSection(),
        ),
      ],
    );
  }

  Future<QuerySnapshot> getRecommendedForYouSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .get();
  }

  Future<QuerySnapshot> getSuggestedForYouSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .get();
  }

  Future<QuerySnapshot> getRecentlyReviewdSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .orderBy("reviews.lastReviewTimestamp", descending: true)
        .get();
  }

  Future<QuerySnapshot> getNewTalentsSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .orderBy("createdAt", descending: true)
        .limit(10)
        .get();
  }

  Future<QuerySnapshot> getTopFreelancerSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .orderBy("reviews.rating", descending: true)
        .get();
  }

  Future<QuerySnapshot> getTeamChoiceFreelancerSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .where("teamChoice", isEqualTo: true)
        .get();
  }

  Future<QuerySnapshot> getBeTheFirstToHireSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .where("jobs", isNull: true)
        .get();
  }

  Future<List<DocumentSnapshot>> getAroundMeSection() {
    // Create a geoFirePoint
    GeoPoint usersLocation = currentUser.location["geopoint"];
    GeoFirePoint center = geo.point(
        latitude: usersLocation.latitude, longitude: usersLocation.longitude);

    double radius = 50;
    String field = 'location';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(
            collectionRef:
                usersRef.where("professionalCategory", whereIn: preferences))
        .within(center: center, radius: radius, field: field);

    return stream.first;
  }
}
