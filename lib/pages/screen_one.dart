import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/freelancer.dart';
import 'package:khadamat/pages/search.dart';
import 'package:khadamat/widgets/screen_layout.dart';

class ScreenOne extends StatefulWidget {
  @override
  _ScreenOne createState() => _ScreenOne();
}

class _ScreenOne extends State<ScreenOne> {
  Map<Tab, StatefulWidget> tabsList = {
    Tab(text: kForYou): Freelancer(),
    Tab(text: kTopFreelancer): Search(),
    Tab(text: kNewTalents): Search(),
    Tab(text: kCategories): Search(),
    Tab(text: kTeamChoice): Search(),
  };
  @override
  Widget build(BuildContext context) {
    return ScreenLayout(tabsList: tabsList);
  }
}
