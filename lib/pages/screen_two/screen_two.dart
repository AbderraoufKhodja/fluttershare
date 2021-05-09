import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/screen_two/proffesional_categories_page.dart';
import 'package:khadamat/widgets/screen_layout.dart';

class ScreenTwo extends StatefulWidget {
  @override
  _ScreenTwo createState() => _ScreenTwo();
}

class _ScreenTwo extends State<ScreenTwo> {
  Map<Tab, StatefulWidget> tabsList = {
    Tab(text: kFreelancersCategories): ProfessionalCategoriesPage(),
    Tab(text: kForYou): ProfessionalCategoriesPage(),
    Tab(text: kTopFreelancer): ProfessionalCategoriesPage(),
    Tab(text: kTrendingFreelancers): ProfessionalCategoriesPage(),
    Tab(text: kTeamChoice): ProfessionalCategoriesPage(),
  };
  @override
  Widget build(BuildContext context) {
    return ScreenLayout(tabsList: tabsList);
  }
}
