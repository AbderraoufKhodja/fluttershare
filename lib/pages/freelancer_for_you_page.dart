import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/items_horizontal_view.dart';

class FreelancerForYouPage extends StatefulWidget {
  final List<dynamic> preferences;

  FreelancerForYouPage({this.preferences});
  @override
  _FreelancerForYouPage createState() => _FreelancerForYouPage();
}

class _FreelancerForYouPage extends State<FreelancerForYouPage>
    with AutomaticKeepAliveClientMixin<FreelancerForYouPage> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  Future<QuerySnapshot> searchResultsFuture;
  final geo = GeoFlutterFire();
  List<dynamic> get preferences => widget.preferences != null
      ? widget.preferences
      : currentUser.preferences.value;

  final int limit = 10;
  @override
  void initState() {
    super.initState();
    // usersRef.get().then(
    //   (documents) {
    //     documents.docs.forEach(
    //       (doc) {
    //         usersRef.doc(doc.id).update({"uid": doc.id});
    //       },
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
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
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot> getSuggestedForYouSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot> getRecentlyReviewdSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .orderBy("reviews.lastReviewTimestamp", descending: true)
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot> getNewTalentsSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .orderBy("createdAt", descending: true)
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot> getTopFreelancerSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .orderBy("globalRate", descending: true)
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot> getTeamChoiceFreelancerSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .where("teamChoice", isEqualTo: true)
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot> getBeTheFirstToHireSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: preferences)
        .where("jobs", isNull: true)
        .limit(limit)
        .get();
  }

  Future<List<DocumentSnapshot>> getAroundMeSection() {
    // Create a geoFirePoint
    GeoPoint usersLocation;
    if (currentUser.location?.value != null) {
      if (currentUser.location.value?.geoFiredata["geopoint"] != null)
        usersLocation = currentUser.location.value.geoFiredata["geopoint"];
      else
        usersLocation = GeoPoint(0, 0);
    } else
      usersLocation = GeoPoint(0, 0);
    GeoFirePoint center = geo.point(
        latitude: usersLocation.latitude, longitude: usersLocation.longitude);

    double radius = 80;
    String field = 'location';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(
            collectionRef:
                usersRef.where("professionalCategory", whereIn: preferences))
        .within(center: center, radius: radius, field: field);

    return stream.first;
  }
}

showFreelancerForYouPage(
  BuildContext context, {
  @required List<dynamic> preferences,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FreelancerForYouPage(
        preferences: preferences,
      ),
    ),
  );
}
