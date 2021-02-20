import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';

class ScreenLayout extends StatelessWidget {
  final bool isScrollable;

  ScreenLayout({
    Key key,
    @required this.tabsList,
    this.isScrollable = true,
  }) : super(key: key);

  final Map<Tab, StatefulWidget> tabsList;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabsList.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.green,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 5,
            isScrollable: isScrollable,
            tabs: tabsList.keys.toList(),
          ),
          title: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SearchBar(
              headerPadding: EdgeInsets.only(left: 0),
              searchBarHeight: 48,
              searchBarStyle: SearchBarStyle(
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          titleSpacing: 0,
        ),
        body: TabBarView(children: tabsList.values.toList()),
        // floatingActionButton: FAB,
      ),
    );
  }
}
