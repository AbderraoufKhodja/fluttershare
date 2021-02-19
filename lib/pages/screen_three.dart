import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/activity_feed.dart';
import 'package:khadamat/pages/manage_jobs_screen.dart';
import 'package:khadamat/pages/messages_screen.dart';
import 'package:khadamat/widgets/screen_layout.dart';

class ScreenThree extends StatefulWidget {
  @override
  _ScreenThree createState() => _ScreenThree();
}

class _ScreenThree extends State<ScreenThree> {
  Map<Tab, StatefulWidget> tabsList = {
    Tab(text: kTimeLine): ActivityFeed(),
    Tab(text: kJobs): ManageJobsScreen(),
    Tab(text: kChats): MessagesScreen(),
  };
  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      tabsList: tabsList,
      isScrollable: false,
    );
  }
}
