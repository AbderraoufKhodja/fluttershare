import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/place_picker_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenLayout extends StatelessWidget {
  final bool isScrollable;
  final bool hasFAB;
  final Function functionFAB;

  ScreenLayout(
      {Key key,
      @required this.tabsList,
      this.isScrollable = true,
      this.hasFAB = false,
      this.functionFAB})
      : super(key: key);

  final Map<Tab, StatefulWidget> tabsList;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabsList.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.location_city,
                          color: Colors.white,
                        ),
                        onPressed: () => showPlacePickerPage(context),
                      ),
                      Text(
                        kLocation,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
                flexibleSpace: GestureDetector(
                  onTap: openAppLink,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Colors.transparent],
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/imihaniBanner.png'),
                      ),
                    ),
                  ),
                ),
                floating: true,
                pinned: true,
                snap: true,
                expandedHeight: MediaQuery.of(context).size.height * 2 / 6,
                collapsedHeight: MediaQuery.of(context).size.height * 1 / 10,
                backgroundColor: Colors.transparent,
                bottom: TabBar(
                  indicatorColor: Colors.green,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.white,
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
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.all(0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                titleSpacing: 0,
              ),
            ];
          },
          body: TabBarView(children: tabsList.values.toList()),
        ),
        floatingActionButton: hasFAB
            ? FloatingActionButton(
                onPressed: functionFAB,
              )
            : null,
      ),
    );
  }

  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openAppLink() {
    print('appBar tapped');
    _launchURL();
  }
}
