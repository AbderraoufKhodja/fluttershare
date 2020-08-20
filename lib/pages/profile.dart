import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/edit_profile.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/upload_card.dart';
import 'package:khadamat/widgets/business_card.dart';
import 'package:khadamat/widgets/post.dart';
import 'package:khadamat/widgets/post_tile.dart';
import 'package:khadamat/widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileId;
  final String jobId;

  Profile({this.profileId, this.jobId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;
  String postOrientation = "grid";
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int hireCount = 0;
  int followingCount = 0;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getHires();
    getFollowing();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await hiresRef
        .document(widget.profileId)
        .collection('userHires')
        .document(currentUserId)
        .collection("Jobs")
        .document(widget.jobId)
        .get();
    setState(() {
      //TODO test this
      isFollowing = doc.exists;
    });
  }

  getHires() async {
    QuerySnapshot snapshot = await hiresRef
        .document(widget.profileId)
        .collection('userHires')
        .getDocuments();
    setState(() {
      hireCount = snapshot.documents.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(widget.profileId)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingCount = snapshot.documents.length;
    });
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .document(widget.profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      isLoading = false;
      postCount = snapshot.documents.length;
      posts = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

//  getProfileCard() async {
//    setState(() {
//      isLoading = true;
//    });
//    QuerySnapshot snapshot = await postsRef
//        .document(widget.profileId)
//        .collection('businessCards')
//        .orderBy('timestamp', descending: true)
//        .getDocuments();
//    setState(() {
//      isLoading = false;
////      postCount = snapshot.documents.length;
//      cards = snapshot.documents.map((doc) => BusinessCard.fromDocument(doc)).toList();
//    });
//  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(currentUserId: currentUserId)));
  }

  createCard() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadCard(currentUser: currentUser)));
  }

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: isFollowing ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Colors.white : Colors.blue,
            border: Border.all(
              color: isFollowing ? Theme.of(context).primaryColor : Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(
        text: "Edit Profile",
        function: editProfile,
      );
    } else if (isFollowing) {
      return buildButton(
        text: "Post a job",
        function: handleUnfollowUser,
      );
    } else if (!isFollowing) {
      return buildButton(
        text: "Accept",
        function: handleFollowUser,
      );
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    // remove hire
    hiresRef
        .document(widget.profileId)
        .collection('userHires')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove following
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete activity feed item for them
    activityFeedRef
        .document(widget.profileId)
        .collection('feedItems')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    // Make auth user hire of THAT user (update THEIR hires collection)
    hiresRef
        .document(widget.profileId)
        .collection('userHires')
        .document(currentUserId)
        .setData({});

    jobsRef
        .document(currentUserId)
        .collection("userJobs")
        .document(widget.jobId)
        .collection("application")
        .document(widget.profileId)
        .setData({
      "accepted": true,
    });
    // Put THAT user on YOUR following collection (update your following collection)
//    followingRef
//        .document(currentUserId)
//        .collection('userFollowing')
//        .document(widget.profileId)
//        .setData({});
    // add activity feed item for that user to notify about new hire (us)
    activityFeedRef
        .document(widget.profileId)
        .collection('feedItems')
        .document(currentUserId)
        .setData({
      "type": "accepted",
      "ownerId": widget.profileId,
      "username": currentUser.username,
      "userId": currentUserId,
      "userProfileImg": currentUser.photoUrl,
      "timestamp": timestamp,
    });

    activityFeedRef
        .document(currentUserId)
        .collection('feedItems')
        .document(widget.profileId)
        .setData({
      "type": "accept",
      "ownerId": widget.profileId,
      "username": currentUser.username,
      "userId": currentUserId,
      "userProfileImg": currentUser.photoUrl,
      "timestamp": timestamp,
    });
  }

  buildProfileHeader() {
    return FutureBuilder(
        future: usersRef.document(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snapshot.data);
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage:
                          CachedNetworkImageProvider(user.photoUrl),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildCountColumn("posts", postCount),
                              buildCountColumn("hires", hireCount),
                              buildCountColumn("following", followingCount),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildProfileButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text(
                    user.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    user.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2.0),
                  child: Text(
                    user.bio,
                  ),
                ),
              ],
            ),
          );
        });
  }

  buildProfileCard() {
    return FutureBuilder(
        future: businessCardsRef
            .document(widget.profileId)
            .collection("businessCards")
            .document("539c9ee2-d02e-4ed1-9281-a3bb554e5d49")
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          BusinessCard card = BusinessCard.fromDocument(snapshot.data);
          return card;
//          return Padding(
//            padding: EdgeInsets.all(16.0),
//            child: Column(
//              children: <Widget>[
//                Row(
//                  children: <Widget>[
//                    CircleAvatar(
//                      radius: 40.0,
//                      backgroundColor: Theme.of(context).primaryColor,
//                      backgroundImage:
//                          CachedNetworkImageProvider(card.mediaUrl),
//                    ),
//                    Expanded(
//                      flex: 1,
//                      child: Column(
//                        children: <Widget>[
//                          Row(
//                            mainAxisSize: MainAxisSize.max,
//                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                            children: <Widget>[
//                              buildCountColumn("posts", postCount),
//                              buildCountColumn("hires", hireCount),
//                              buildCountColumn("following", followingCount),
//                            ],
//                          ),
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                            children: <Widget>[
//                              buildProfileButton(),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//                Container(
//                  alignment: Alignment.centerLeft,
//                  padding: EdgeInsets.only(top: 12.0),
//                  child: Text(
//                    card.username,
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      fontSize: 16.0,
//                    ),
//                  ),
//                ),
//                Container(
//                  alignment: Alignment.centerLeft,
//                  padding: EdgeInsets.only(top: 4.0),
//                  child: Text(
//                    card.jobCategory,
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                ),
//                Container(
//                  alignment: Alignment.centerLeft,
//                  padding: EdgeInsets.only(top: 2.0),
//                  child: Text(
//                    card.bio,
//                  ),
//                ),
//              ],
//            ),
//          );
        });
  }

  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/no_content.svg', height: 260.0),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "No Posts",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (postOrientation == "grid") {
      List<GridTile> gridTiles = [];
      posts.forEach((post) {
        gridTiles.add(GridTile(child: PostTile(post)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (postOrientation == "list") {
      return Column(
        children: posts,
      );
    }
  }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }

  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setPostOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == 'grid'
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor,
        ),
        IconButton(
          onPressed: () => setPostOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == 'list'
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
//      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
//          buildButton(text: "create card", function: createCard):cards,
          buildProfileCard(),
          Divider(),
          buildTogglePostOrientation(),
          Divider(
            height: 0.0,
          ),
          buildProfilePosts(),
        ],
      ),
    );
  }
}
