import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/items_horizontal_view.dart';

class TopFreelancerPage extends StatefulWidget {
  @override
  _TopFreelancerPage createState() => _TopFreelancerPage();
}

class _TopFreelancerPage extends State<TopFreelancerPage> {
  Future<QuerySnapshot> searchResultsFuture;
  List<String> popularCategories = ["Developper"];

  @override
  void initState() {
    super.initState();
    getPopularCategories();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 20, top: 20),
      children: [
        ItemsHorizontalView(
          title: kTopRated,
          futureItems: getTopRatedSection(),
        ),
        ItemsHorizontalView(
          title: kMostExperienced,
          futureItems: getMostExperiencedSection(),
        ),
        ItemsHorizontalView(
          title: kHighestCompletionRate,
          futureItems: getHighestCompletionRateSection(),
        ),
        ItemsHorizontalView(
          title: kPopularAdvisors,
          futureItems: getPopularAdvisorsSection(),
        ),
        ItemsHorizontalView(
          title: kTopFreelancersAroundMe,
          futureItems: getTopFreelancersAroundMeSection(),
        ),
        ItemsHorizontalView(
          title: kTopTeamChoiceFreelancers,
          futureItems: getTopTeamChoiceFreelancersSection(),
        ),
        ItemsHorizontalView(
          title: kFastCompletions,
          futureItems: getFastCompletionsSection(),
        ),
        ItemsHorizontalView(
          title: kHighQualityFreelancers,
          futureItems: getHighQualityFreelancersSection(),
        ),
      ],
    );
  }

  Future<QuerySnapshot> getTopRatedSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .orderBy("globalRate", descending: true)
        .getDocuments();
  }

  Future<QuerySnapshot> getMostExperiencedSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .orderBy("experienceRate", descending: true)
        .getDocuments();
  }

  Future<QuerySnapshot> getHighestCompletionRateSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .orderBy("completionRate", descending: true)
        .getDocuments();
  }

  Future<QuerySnapshot> getPopularAdvisorsSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .orderBy("popularityRate", descending: true)
        .limit(10)
        .getDocuments();
  }

  Future<QuerySnapshot> getTopFreelancersAroundMeSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .orderBy("location", descending: true)
        .orderBy("experienceRate", descending: true)
        .getDocuments();
  }

  Future<QuerySnapshot> getTopTeamChoiceFreelancersSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .where("teamChoice", isEqualTo: true)
        .orderBy("globalRate", descending: true)
        .getDocuments();
  }

  Future<QuerySnapshot> getFastCompletionsSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .orderBy("reviews.rating", descending: true)
        .getDocuments();
  }

  Future<QuerySnapshot> getHighQualityFreelancersSection() {
    return usersRef
        .where("isFreelancer", isEqualTo: true)
        .where("professionalCategory", whereIn: popularCategories)
        .orderBy("reviews.rating", descending: true)
        .getDocuments();
  }

  Future<void> getPopularCategories() async {
    QuerySnapshot snap = await popularCategoriesRef.getDocuments();
    setState(() {
      popularCategories = snap.documents.map((doc) => doc.documentID).toList();
    });
  }
}
