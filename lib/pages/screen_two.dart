import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/proffesional_categories_page.dart';
import 'package:khadamat/pages/search.dart';
import 'package:khadamat/widgets/screen_layout.dart';

class ScreenTwo extends StatefulWidget {
  @override
  _ScreenTwo createState() => _ScreenTwo();
}

class _ScreenTwo extends State<ScreenTwo> {
  Map<Tab, StatefulWidget> tabsList = {
    Tab(text: kFreelancersCategories): ProfessionalCategoriesPage(),
    Tab(text: kForYou): Search(),
    Tab(text: kTopFreelancer): Search(),
    Tab(text: kTrendingFreelancers): Search(),
    Tab(text: kTeamChoice): Search(),
  };
  @override
  Widget build(BuildContext context) {
    return ScreenLayout(tabsList: tabsList);
  }
}
