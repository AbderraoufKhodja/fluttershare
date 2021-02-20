import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/items_horizontal_view.dart';

class FreelancerForYouPage extends StatefulWidget {
  final List<dynamic> preferences;

  FreelancerForYouPage({this.preferences});
  @override
  _FreelancerForYouPage createState() => _FreelancerForYouPage();
}

class _FreelancerForYouPage extends State<FreelancerForYouPage> {
  Future<QuerySnapshot> searchResultsFuture;
  final geo = Geoflutterfire();
  List<dynamic> get preferences => widget.preferences != null
      ? widget.preferences
      : currentUser.preferences.value;

  final int limit = 15;
  @override
  void initState() {
    super.initState();
    // usersRef.get().then(
    //   (documents) {
    //     print(documents.docs.length);
    //     Random random = new Random();
    //     documents.docs.forEach(
    //       (doc) {
    //         final int a_year = random.nextInt(24) + 1980;
    //         final int a_month = random.nextInt(5);
    //         final int a_day = random.nextInt(20);
    //         final int b_year = a_year + random.nextInt(20);
    //         final int b_month = a_month + random.nextInt(2);
    //         final int b_day = a_day + random.nextInt(4);
    //         final int c_year = b_year;
    //         final int c_month = b_month + random.nextInt(5);
    //         final int c_day = b_day + random.nextInt(5);
    //         usersRef.doc(doc.id).update(
    //           {
    //             'birthDate':
    //                 Timestamp.fromDate(DateTime(a_year, a_month, a_day)),
    //             'createdAt':
    //                 Timestamp.fromDate(DateTime(b_year, b_month, b_day)),
    //             "reviews.lastReviewTimestamp":
    //                 Timestamp.fromDate(DateTime(c_year, c_month, c_day)),
    //           },
    //         );
    //       },
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    if (currentUser.location.value != null) {
      if (currentUser.location.value.containsKey("geopoint"))
        usersLocation = currentUser.location.value["geopoint"];
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
