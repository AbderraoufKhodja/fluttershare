import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/activity_feed.dart';
import 'package:khadamat/pages/manage_jobs_screen.dart';
import 'package:khadamat/pages/messages_screen.dart';
import 'package:khadamat/widgets/screen_layout.dart';

class ScreenFour extends StatefulWidget {
  @override
  _ScreenFour createState() => _ScreenFour();
}

class _ScreenFour extends State<ScreenFour> {
  Map<Tab, StatefulWidget> tabsList = {
    const Tab(text: kMySubscriptions): ActivityFeed(),
    const Tab(text: kTopForums): ManageJobsScreen(),
    const Tab(text: kCategories): MessagesScreen(),
    const Tab(text: kHotTopics): MessagesScreen(),
    const Tab(text: kPopularPosts): MessagesScreen()
  };
  @override
  Widget build(BuildContext context) {
    return ScreenLayout(tabsList: tabsList);
  }
}

