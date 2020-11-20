import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/activity_feed.dart';
import 'package:khadamat/pages/manage_jobs_screen.dart';
import 'package:khadamat/pages/messages_screen.dart';

class ScreenThree extends StatefulWidget {
  @override
  _ScreenThree createState() => _ScreenThree();
}

class _ScreenThree extends State<ScreenThree> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.green,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 5,
            isScrollable: false,
            tabs: [
              Tab(text: kTimeLine),
              Tab(text: kJobs),
              Tab(text: kChats),
            ],
          ),
          title: Container(
            height: 90,
            child: SearchBar(
              searchBarPadding: EdgeInsets.only(top: 5),
              searchBarStyle: SearchBarStyle(
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        body: TabBarView(children: [
          ActivityFeed(),
          ManageJobsScreen(),
          MessagesScreen(),
        ]),
      ),
    );
  }
}
