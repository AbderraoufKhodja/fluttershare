import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/models/review.dart';
import 'package:khadamat/pages/create_freelance_account.dart';
import 'package:khadamat/pages/edit_profile.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/messages_page.dart';
import 'package:khadamat/widgets/post.dart';
import 'package:khadamat/widgets/post_tile.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class Profile extends StatefulWidget {
  final String profileId;
  final Job job;

  Profile({this.profileId, this.job});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  AppUser user;
  String selectedTab = "info";
  String formattedAddress = "";
  bool isHired = false;
  bool isLoading = false;
  int postCount = 0;
  List<Post> posts = [];

  bool get isApplicationResponse {
    return job != null &&
        job.applications.value[widget.profileId] == null &&
        job.jobOwnerId.value != widget.profileId &&
        job.jobOwnerId.value == currentUser.uid.value &&
        job.jobState.value == "open" &&
        job.isOwnerCompleted.value == false;
  }

  Job get job => widget.job;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getProfilePosts();
    checkIfHired();
    formatLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return linearProgress();
          user = AppUser.fromDocument(snapshot.data);
          return user.isFreelancer.value
              ? buildFreelancerScreen(context)
              : buildClientScreen(context);
        });
  }

  Scaffold buildClientScreen(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(),
          Container(
            height: MediaQuery.of(context).size.height * 3 / 5,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white),
            child: buildButton(
                text: kCreateCard,
                function: () =>
                    showCreateFreelanceAccount(context, appUser: currentUser)),
          ),
        ],
      ),
    );
  }

  SafeArea buildFreelancerScreen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            buildProfileHeader(),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 3 / 5,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    color: Colors.blueGrey),
                child: Column(
                  children: [
                    buildToggleTab(),
                    Divider(height: 0.0, indent: 30.0, endIndent: 30.0),
                    buildContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildProfileHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(100.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage:
                          CachedNetworkImageProvider(kBlankProfileUrl),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildCountColumn(kRating, 0),
                              buildCountColumn(kJobsCount, 0),
                              buildCountColumn(kEvaluation, 0),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[350],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        AppUser user = AppUser.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: CircleAvatar(
                  radius: 100.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: CachedNetworkImageProvider(
                      user.professionalPhotoUrl.value ?? kBlankProfileUrl),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        user.username.value ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        user.professionalTitle.value.toUpperCase() ?? "",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        user.achievement.value ?? "",
                        style: GoogleFonts.lato(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    buildCountColumn(kRating, user.globalRate.value),
                    buildCountColumn(kJobsCount, getCompletedJobsCount()),
                    buildCountColumn(kEvaluation, getEvaluation()),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: buildProfileButton(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildProfileInfo() {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 0.1,
      crossAxisSpacing: 0,
      shrinkWrap: true,
      childAspectRatio: 1,
      physics: BouncingScrollPhysics(),
      children: [
        buildProfileInfoField(label: kUsername, text: user.username.value),
        buildProfileInfoField(
            label: kPersonalBio, text: user.personalBio.value),
        buildProfileInfoField(label: kLocation, text: formattedAddress),
        buildProfileInfoField(
            label: kBirthDate,
            text: timeago.format(
                user.birthDate.value?.toDate() ?? Timestamp.now().toDate())),
        buildProfileInfoField(
            label: kProfessionalCategory,
            text: user.professionalCategory.value),
        buildProfileInfoField(
            label: kProfessionalTitle, text: user.professionalTitle.value),
        buildProfileInfoField(
            label: kProfessionalDescription,
            text: user.professionalDescription.value),
        buildProfileInfoField(
            label: kPreferences, text: user.preferences.value.toString()),
        buildProfileInfoField(
            label: kCreatedAt,
            text: timeago.format(
                user.createdAt.value?.toDate() ?? Timestamp.now().toDate())),
        // buildProfileInfoField(label: kGender, text: user.gender.value),
        // buildProfileInfoField(label: kEmail, text: user.email.value),
        // buildProfileInfoField(label: kDiploma, text: user.diploma.value),
        // buildProfileInfoField(label: kLicence, text: user.licence.value),
        // buildProfileInfoField(
        //     label: kCertification, text: user.certification.value),
        // buildProfileInfoField(label: kLanguage, text: user.language.value),
        // buildProfileInfoField(
        //     label: kExperience, text: user.experience.value),
        // buildProfileInfoField(
        //     label: kInternship, text: user.internship.value),
        // buildProfileInfoField(
        //     label: kCompetence, text: user.competence.value),
        // buildProfileInfoField(
        //     label: kAchievement, text: user.achievement.value),
        // buildProfileInfoField(
        //     label: kRecommendation, text: user.recommendation.value),
      ]
          .map((tile) => GridTile(
                child: tile,
              ))
          .toList(),
    );
  }

  Column buildProfileInfoField(
      {@required String label, @required String text}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label ",
              style: kTextStyleProfileInfoHeader,
            ),
            Text(
              "$text",
              style: kTextStyleProfileInfo,
            ),
          ],
        ),
        Divider(height: 0.0, indent: 30.0, endIndent: 30.0),
      ],
    );
  }

  buildProfileReviews() {
    List<Review> reviews = [];
    if (user.reviews.value != null)
      user.reviews.value.values.forEach((review) {
        if (review is Map<String, dynamic>)
          reviews.add(Review.fromDocument(review));
      });
    return reviews.isNotEmpty
        ? Center(
            child: Column(
              children: reviews
                  .map(
                      (review) => Text(review.freelancerReview ?? kMissingData))
                  .toList(),
            ),
          )
        : Center(child: Text(kHasNoReview));
  }

  buildProfileGallery() {
    if (isLoading) {
      return linearProgress();
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
    } else if (true) {
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
    } else if (selectedTab == "list") {
      return Column(
        children: posts,
      );
    }
  }

  buildToggleTab() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setTab("info"),
          icon: Icon(Icons.info),
          color: selectedTab == 'info'
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
        ),
        IconButton(
          onPressed: () => setTab("review"),
          icon: Icon(Icons.list),
          color: selectedTab == 'review'
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
        ),
        IconButton(
          onPressed: () => setTab("gallery"),
          icon: Icon(Icons.grid_on),
          color: selectedTab == 'gallery'
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  buildContent() {
    if (selectedTab == "info") return buildProfileInfo();
    if (selectedTab == "review") return buildProfileReviews();
    if (selectedTab == "gallery") return buildProfileGallery();
  }

  Widget buildAcceptRejectButtons() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildButton(
          text: kReject,
          fillColor: Colors.red,
          function: () {
            toggleIsLoading();
            handleRejectApplication().then((value) {
              toggleIsLoading();
              Navigator.pop(context);
            });
          },
        ),
        buildButton(
          text: kAccept,
          fillColor: Colors.green,
          function: () async {
            toggleIsLoading();
            handleAcceptApplication();
            toggleIsLoading();
            Navigator.pop(context);
            showMessagesScreen(context);
          },
        ),
      ],
    );
  }

  Column buildCountColumn(String label, var count) {
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

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = currentUser.uid.value == widget.profileId;

    if (isProfileOwner) {
      return buildButton(
        text: kEditProfile,
        function: () => showEditProfile(context),
      );
    } else if (!isHired && !isApplicationResponse)
      return buildButton(
        text: kHire,
        function: handleHireUser,
      );
    else if (!isHired && isApplicationResponse)
      buildAcceptRejectButtons();
    else
      return Container();
  }

  Future<void> handleUnfollowUser() async {
    setState(() {
      isHired = false;
    });
    // remove hire
    hiresRef
        .doc(widget.profileId)
        .collection('userHires')
        .doc(currentUser.uid.value)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove following
    hiresRef
        .doc(currentUser.uid.value)
        .collection('userHires')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete activity feed item for them
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUser.uid.value)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  Future<void> handleHireUser() async {
    // TODO implement hire function

    setState(() {
      isHired = true;
    });
    // Make auth user hire of THAT user (update THEIR hires collection)
    hiresRef
        .doc(widget.profileId)
        .collection('userHires')
        .doc(currentUser.uid.value)
        .set({});

    jobsRef
        .doc(currentUser.uid.value)
        .collection("userJobs")
        .doc(job.jobId.value)
        .collection("application")
        .doc(widget.profileId)
        .set({
      "accepted": true,
    });
    // Put THAT user on YOUR following collection (update your following collection)
//    followingRef
//        .doc(currentUser.uid.value)
//        .collection('userFollowing')
//        .doc(widget.profileId)
//        .set({});
    // add activity feed item for that user to notify about new hire (us)
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUser.uid.value)
        .set({
      "type": "accepted",
      "jobOwnerId": widget.profileId,
      "username": currentUser.username.value,
      "userId": currentUser.uid.value,
      "userProfileImg": currentUser.photoURL.value,
      "createdAt": FieldValue.serverTimestamp(),
    });

    activityFeedRef
        .doc(currentUser.uid.value)
        .collection('feedItems')
        .doc(widget.profileId)
        .set({
      "type": "accept",
      "jobOwnerId": widget.profileId,
      "username": currentUser.username.value,
      "userId": currentUser.uid.value,
      "userProfileImg": currentUser.photoURL.value,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> handleRejectApplication() {
    return job.handleRejectApplication(
      applicantId: user.uid.value,
      applicantName: user.username.value,
    );
  }

  Future<void> handleAcceptApplication() async {
    return job
        .handleAcceptApplication(
      applicantId: user.uid.value,
      applicantName: user.username.value,
      applicantEmail: user.email.value,
    )
        .then((value) {
      job.jobFreelancerId.value = user.uid.value;
      job.jobFreelancerName.value = user.username.value;
      job.jobFreelancerEmail.value = user.email.value;
      job.jobState.value = "onGoing";
    });
  }

  Future<void> checkIfHired() async {
    DocumentSnapshot doc = await jobsRef
        .doc(widget.profileId)
        .collection("userJobs")
        .doc("jobId")
        .get();
    setState(() {
      isHired = doc.exists;
    });
  }

  double getEvaluation() {
    double count = 0;
    if ((user.reviews.value?.values?.length ?? 0) > 2)
      // ignore: null_aware_before_operator
      count = user.reviews.value?.values?.length - 2.0;
    return count;
  }

  double getCompletedJobsCount() {
    double count = 0;
    user.jobs.value?.values?.forEach((element) {
      if (element['isCompleted'] == true) count += 1;
    });
    return count;
  }

  Future<void> getProfilePosts() async {
    toggleIsLoading();
    QuerySnapshot snapshot = await postsRef
        .doc(widget.profileId)
        .collection('userPosts')
        .orderBy('createdAt', descending: true)
        .get();
    toggleIsLoading();
    setState(() {
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  setTab(String label) {
    setState(() {
      this.selectedTab = label;
    });
  }

  Container buildButton(
      {String text, Color fillColor = Colors.blue, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: TextButton(
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

  Future<void> formatLocation() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentUser.location.value.geoFiredata["geopoint"].latitude,
        currentUser.location.value.geoFiredata["geopoint"].longitude);
    Placemark placemark = placemarks[0];
    String formattedAddress =
        " ${placemark.subAdministrativeArea}, ${placemark.administrativeArea},"
        " ${placemark.country}";
    setState(() {
      this.formattedAddress = formattedAddress;
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
        job: job,
      ),
    ),
  );
}
