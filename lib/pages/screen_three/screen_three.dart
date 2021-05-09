import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/screen_three/activity_feed_page.dart';
import 'package:khadamat/pages/screen_three/manage_jobs_page.dart';
import 'package:khadamat/pages/screen_three/messages_page.dart';
import 'package:khadamat/widgets/screen_layout.dart';

class ScreenThree extends StatefulWidget {
  @override
  _ScreenThree createState() => _ScreenThree();
}

class _ScreenThree extends State<ScreenThree> {
  Map<Tab, StatefulWidget> tabsList = {
    Tab(text: kTimeLine): ActivityFeedPage(),
    Tab(text: kJobs): ManageJobsPage(),
    Tab(text: kChats): MessagesPage(),
  };
  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      tabsList: tabsList,
      isScrollable: false,
    );
  }
}
