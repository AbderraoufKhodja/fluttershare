import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/create_account.dart';
import 'package:khadamat/pages/job_activity_feed.dart';
import 'package:khadamat/pages/job_timeline.dart';
import 'package:khadamat/pages/profile.dart';
import 'package:khadamat/pages/search.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khadamat/pages/upload_job.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = Firestore.instance.collection('users');
final cardsRef = Firestore.instance.collection('cards');
final postsRef = Firestore.instance.collection('posts');
final jobsRef = Firestore.instance.collection('jobs');
final categoriesRef = Firestore.instance.collection('categories');
final commentsRef = Firestore.instance.collection('comments');
final reviewsRef = Firestore.instance.collection('reviews');
final messagesRef = Firestore.instance.collection('messages');
final activityFeedRef = Firestore.instance.collection('feeds');
final hiresRef = Firestore.instance.collection('hires');
final followingRef = Firestore.instance.collection('following');
final timelineRef = Firestore.instance.collection('timeline');
final jobTimelineRef = Firestore.instance.collection('timeline');
final DateTime currentTimestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  bool isFreelancer = false;
  String category;
  String subCategory;
  String jobTitle;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      bool isSuccessful = await createUserInFirestore();
      print("isSuccessful: $isSuccessful");
      if (isSuccessful == true) {
        setState(() {
          isAuth = true;
        });
        configurePushNotifications();
      }
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  configurePushNotifications() {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    if (Platform.isIOS) getiOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Messaging Token: $token\n");
      usersRef
          .document(user.id)
          .updateData({"androidNotificationToken": token});
    });

    _firebaseMessaging.configure(
      // onLaunch: (Map<String, dynamic> message) async {},
      // onResume: (Map<String, dynamic> message) async {},
      onMessage: (Map<String, dynamic> message) async {
        print("on message: $message\n");
        final String recipientId = message['data']['recipient'];
        final String body = message['notification']['body'];
        if (recipientId == user.id) {
          print("Notification shown!");
          SnackBar snackbar = SnackBar(
              content: Text(
            body,
            overflow: TextOverflow.ellipsis,
          ));
          _scaffoldKey.currentState.showSnackBar(snackbar);
        }
        print("Notification NOT shown");
      },
    );
  }

  getiOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(alert: true, badge: true, sound: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      print("Settings registered: $settings");
    });
  }

  Future<bool> createUserInFirestore() async {
    bool isSuccessful = true;
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      isSuccessful = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateAccount(
                    googleUser: user,
                  )));
      print("isCreated : $isSuccessful");
      if (isSuccessful == true) {
        // 3) get username from create account, use it to make new user document in users collection
        doc = await usersRef.document(user.id).get();
        currentUser = User.fromDocument(doc);
      } else
        logout();

      return isSuccessful;
    }

    currentUser = User.fromDocument(doc);
    return isSuccessful;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          JobTimeline(currentUser: currentUser),
//          CreateAccount(),
          JobActivityFeed(),
          UploadJob(currentUser: currentUser),
          Search(),
          Profile(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        border: Border(top: BorderSide.none),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        inactiveColor: Theme.of(context).primaryColor,
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(OMIcons.whatshot),
            activeIcon: Icon(Icons.whatshot, size: 40.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(OMIcons.notificationsActive),
            activeIcon: Icon(Icons.notifications_active, size: 40.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(OMIcons.photoCamera),
            activeIcon: Icon(Icons.photo_camera, size: 40.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(OMIcons.search),
            activeIcon: Icon(Icons.search, size: 40.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(OMIcons.accountCircle),
            activeIcon: Icon(Icons.account_circle, size: 40.0),
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'المهَنــي',
              style: TextStyle(
                fontFamily: "ReemKufi-Regular",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/google_signin_button.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
