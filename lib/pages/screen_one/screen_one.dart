import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/screen_one/freelancer_categories_page.dart';
import 'package:khadamat/pages/screen_one/freelancer_for_you_page.dart';
import 'package:khadamat/pages/screen_one/team_choice_freelancers_page.dart';
import 'package:khadamat/pages/screen_one/top_freelancer_page.dart';
import 'package:khadamat/pages/screen_one/trending_freelancers_page.dart';
import 'package:khadamat/widgets/screen_layout.dart';

class ScreenOne extends StatefulWidget {
  @override
  _ScreenOne createState() => _ScreenOne();
}

class _ScreenOne extends State<ScreenOne> {
  Map<Tab, StatefulWidget> tabsList = {
    Tab(text: kForYou): FreelancerForYouPage(),
    Tab(text: kTopFreelancer): TopFreelancerPage(),
    Tab(text: kTrendingFreelancers): TrendingFreelancersPage(),
    Tab(text: kFreelancersCategories): FreelancerCategoriesPage(),
    Tab(text: kTeamChoice): TeamChoiceFreelancerPage(),
  };
  @override
  Widget build(BuildContext context) {
    return ScreenLayout(tabsList: tabsList);
  }
}
