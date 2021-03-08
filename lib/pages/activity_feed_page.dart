import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/activity_feed.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/activity_feed_item.dart';
import 'package:khadamat/widgets/progress.dart';

class ActivityFeedPage extends StatefulWidget {
  @override
  _ActivityFeedPageState createState() => _ActivityFeedPageState();
}

class _ActivityFeedPageState extends State<ActivityFeedPage>
    with AutomaticKeepAliveClientMixin<ActivityFeedPage> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        body: Container(
          child: StreamBuilder(
            stream: getActivityFeed(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              if (snapshot.data == null) {
                return Center(child: Text(kEmpty));
              }
              List<ActivityFeedItem> feedItems = [];
              snapshot.data.docs.forEach((doc) {
                feedItems.add(ActivityFeedItem(
                  feed: ActivityFeed.fromDocument(doc),
                ));
              });
              return ListView(
                physics: BouncingScrollPhysics(),
                children: feedItems,
              );
            },
          ),
        ),
      ),
    );
  }

  getActivityFeed() {
    return activityFeedRef
        .doc(currentUser.uid.value)
        .collection('feedItems')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots();
  }

  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
