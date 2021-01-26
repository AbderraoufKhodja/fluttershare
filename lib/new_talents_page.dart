import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/items_horizontal_view.dart';

class NewTalentsPage extends StatefulWidget {
  @override
  _NewTalentsPage createState() => _NewTalentsPage();
}

class _NewTalentsPage extends State<NewTalentsPage> {
  Future<QuerySnapshot> searchResultsFuture;

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
        .where("professionalCategory", whereIn: currentUser.preferences)
        .get();
  }

  Future<QuerySnapshot> getSuggestedForYouSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: currentUser.preferences)
        .get();
  }

  Future<QuerySnapshot> getRecentlyReviewdSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: currentUser.preferences)
        .orderBy("reviews.lastReviewTimestamp", descending: true)
        .get();
  }

  Future<QuerySnapshot> getNewTalentsSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: currentUser.preferences)
        .orderBy("createdAt", descending: true)
        .limit(10)
        .get();
  }

  Future<QuerySnapshot> getTopFreelancerSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: currentUser.preferences)
        .orderBy("reviews.rating", descending: true)
        .get();
  }

  Future<QuerySnapshot> getTeamChoiceFreelancerSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: currentUser.preferences)
        .where("teamChoice", isEqualTo: true)
        .get();
  }

  Future<QuerySnapshot> getBeTheFirstToHireSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: currentUser.preferences)
        .where("jobs", isNull: true)
        .get();
  }

  Future<QuerySnapshot> getAroundMeSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: currentUser.preferences)
        .get();
  }
}
