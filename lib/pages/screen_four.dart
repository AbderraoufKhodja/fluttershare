import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/manage_jobs_page.dart';
import 'package:khadamat/pages/messages_page.dart';
import 'package:khadamat/pages/my_forum_subscribtions_page.dart';
import 'package:khadamat/widgets/screen_layout.dart';

class ScreenFour extends StatefulWidget {
  @override
  _ScreenFour createState() => _ScreenFour();
}

class _ScreenFour extends State<ScreenFour> {
  Map<Tab, StatefulWidget> tabsList = {
    const Tab(text: kMySubscriptions): MyForumSubscribtionsPage(),
    const Tab(text: kTopForums): ManageJobsPage(),
    const Tab(text: kFreelancersCategories): MessagesPage(),
    const Tab(text: kHotTopics): MessagesPage(),
    const Tab(text: kPopularPosts): MessagesPage()
  };
  @override
  Widget build(BuildContext context) {
    return ScreenLayout(tabsList: tabsList);
  }
}
