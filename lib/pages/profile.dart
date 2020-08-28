import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/edit_profile.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/messages_screen.dart';
import 'package:khadamat/pages/upload_card.dart';
import 'package:khadamat/widgets/business_card.dart';
import 'package:khadamat/widgets/post.dart';
import 'package:khadamat/widgets/post_tile.dart';
import 'package:khadamat/widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileId;
  final Job job;
  final String profileName;

  Profile({this.profileId, this.job, this.profileName});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;
  String postOrientation = "grid";
  bool isHired = false;
  bool isLoading = false;
  bool isApplicationResponse = false;
  int postCount = 0;
  int hireCount = 0;
  int followingCount = 0;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getHires();
    getHired();
    checkIfHired();
    checkIfApplicationResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
//      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
//          buildProfileCard(),
          Divider(),
          buildTogglePostOrientation(),
          Divider(
            height: 0.0,
          ),
          buildProfilePosts(),
        ],
      ),
      appBar: isApplicationResponse
          ? AppBar(
              actions: [
                Expanded(
                    child: buildButton(
                  text: kReject,
                  fillColor: Colors.red,
                  function: handleRejectApplication,
                )),
                Expanded(
                    child: buildButton(
                  text: kAccept,
                  fillColor: Colors.green,
                  function: () {
                    handleAcceptApplication();
                    setState(() {
                      isApplicationResponse = false;
                    });
                    showMessageScreen(context);
                  },
                )),
              ],
            )
          : null,
    );
  }

  checkIfHired() async {
    DocumentSnapshot doc = await jobsRef
        .document(widget.profileId)
        .collection("userJobs")
        .document("widget.job.jobId")
        .get();
    setState(() {
      isHired = doc.exists;
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

  getHired() async {
    QuerySnapshot snapshot = await hiresRef
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

  Container buildButton(
      {String text, Color fillColor = Colors.blue, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 200.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: isHired ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(
              color: fillColor,
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
    } else if (!isHired) {
      return buildButton(
        text: "Hire",
        function: handleHireUser,
      );
    }
//    else if (isApplicationResponse) {
//      return buildButton(
//        text: "Post a job",
//        function: handleUnfollowUser,
//      );
//    }
  }

  handleUnfollowUser() {
    setState(() {
      isHired = false;
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

  handleHireUser() {
    // TODO implement hire function

    setState(() {
      isHired = true;
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
        .document(widget.job.jobId)
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
      "jobOwnerId": widget.profileId,
      "username": currentUser.username,
      "userId": currentUserId,
      "userProfileImg": currentUser.photoUrl,
      "timestamp": currentTimestamp,
    });

    activityFeedRef
        .document(currentUserId)
        .collection('feedItems')
        .document(widget.profileId)
        .setData({
      "type": "accept",
      "jobOwnerId": widget.profileId,
      "username": currentUser.username,
      "userId": currentUserId,
      "userProfileImg": currentUser.photoUrl,
      "timestamp": currentTimestamp,
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
        future: cardsRef.document(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          print(snapshot.data);
          DocumentSnapshot doc = snapshot.data;
          if (doc.exists) {
            BusinessCard card = BusinessCard.fromDocument(doc);
            return card;
          } else {
            return buildButton(text: "Create card", function: createCard);
          }
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

  handleRejectApplication() {
    jobsRef.document(widget.job.jobId).updateData({
      'applications.${widget.profileId}': FieldValue.delete()
    }).then((value) => widget.job.applications.remove(widget.profileId));
    widget.job.addRejectToActivityFeed(
        applicantId: widget.profileId, applicantName: widget.profileName);
  }

  handleAcceptApplication() async {
    await jobsRef
        .document(widget.job.jobId)
        .updateData({'applications.${widget.profileId}': true}).then(
            (value) => widget.job.applications[widget.profileId] = true);
    widget.job.addAcceptToActivityFeed(
        applicantId: widget.profileId,
        applicantName: widget.profileName,
        jobOwnerId: widget.job.jobOwnerId);
  }

  checkIfApplicationResponse() {
    setState(() {
      isApplicationResponse = widget.job != null &&
          widget.job.applications[widget.profileId] == null &&
          widget.job.jobOwnerId != widget.profileId;
    });
  }
}

showProfile(BuildContext context,
    {@required String profileId, @required String profileName, Job job}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Profile(
        profileId: profileId,
        profileName: profileName,
        job: job,
      ),
    ),
  );
}
