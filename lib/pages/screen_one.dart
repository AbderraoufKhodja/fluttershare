import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/freelancer.dart';
import 'package:khadamat/pages/search.dart';

class ScreenOne extends StatefulWidget {
  @override
  _ScreenOne createState() => _ScreenOne();
}

class _ScreenOne extends State<ScreenOne> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.green,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 5,
            isScrollable: true,
            tabs: [
              Tab(text: kForYou),
              Tab(text: kTopFreelancer),
              Tab(text: kNew),
              Tab(text: kCategories),
              Tab(text: kCategories),
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
          Freelancer(),
          Search(),
          Search(),
          Search(),
          Search(),
        ]),
      ),
    );
  }
}
