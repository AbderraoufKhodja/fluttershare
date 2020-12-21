import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/items_horizontal_view.dart';

class Freelancer extends StatefulWidget {
  @override
  _Freelancer createState() => _Freelancer();
}

class _Freelancer extends State<Freelancer> {
  Future<QuerySnapshot> searchResultsFuture;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 20, top: 20),
      children: [
        ItemsHorizontalView(
          title: kRecommendedForYouSection,
          futureItems: getRecommendedForYouSectiont(),
        ),
        ItemsHorizontalView(
          title: kSuggestedForYouSection,
          futureItems: getSuggestedForYouSectionet(),
        ),
        ItemsHorizontalView(
          title: kRecentlyReviewdSection,
          futureItems: getRecentlyReviewdSectiont(),
        ),
        ItemsHorizontalView(
          title: kNewTalentsSection,
          futureItems: getNewTalentsSectiont(),
        ),
        ItemsHorizontalView(
          title: kTopFreelancerSection,
          futureItems: getTopFreelancerSectiont(),
        ),
        ItemsHorizontalView(
          title: kTeamChoiceFreelancers,
          futureItems: getTeamChoiceFreelancerst(),
        ),
        ItemsHorizontalView(
          title: kBeTheFirstToHire,
          futureItems: getBeTheFirstToHiret(),
        ),
        ItemsHorizontalView(
          title: kAroundMe,
          futureItems: getAroundMe(),
        ),
      ],
    );
  }

  Future<QuerySnapshot> getRecommendedForYouSectiont() {
    return usersRef.where("isFreelancer", isEqualTo: true).getDocuments();
  }

  Future<QuerySnapshot> getSuggestedForYouSectionet() {
    return usersRef.where("isFreelancer", isEqualTo: true).getDocuments();
  }

  Future<QuerySnapshot> getRecentlyReviewdSectiont() {
    return usersRef.where("isFreelancer", isEqualTo: true).getDocuments();
  }

  Future<QuerySnapshot> getNewTalentsSectiont() {
    return usersRef.where("isFreelancer", isEqualTo: true).getDocuments();
  }

  Future<QuerySnapshot> getTopFreelancerSectiont() {
    return usersRef.where("isFreelancer", isEqualTo: true).getDocuments();
  }

  Future<QuerySnapshot> getTeamChoiceFreelancerst() {
    return usersRef.where("isFreelancer", isEqualTo: true).getDocuments();
  }

  Future<QuerySnapshot> getBeTheFirstToHiret() {
    return usersRef.where("isFreelancer", isEqualTo: true).getDocuments();
  }

  Future<QuerySnapshot> getAroundMe() {
    return usersRef.where("isFreelancer", isEqualTo: true).getDocuments();
  }
}
