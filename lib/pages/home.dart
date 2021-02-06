import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/pages/create_account.dart';
import 'package:khadamat/pages/profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khadamat/pages/screen_four.dart';
import 'package:khadamat/pages/screen_one.dart';
import 'package:khadamat/pages/screen_three.dart';
import 'package:khadamat/pages/screen_two.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef = FirebaseStorage.instance.ref();
final FirebaseAuth auth = FirebaseAuth.instance;
final usersRef = FirebaseFirestore.instance.collection('users');
final cardsRef = FirebaseFirestore.instance.collection('cards');
final postsRef = FirebaseFirestore.instance.collection('posts');
final jobsRef = FirebaseFirestore.instance.collection('jobs');
final popularCategoriesRef =
    FirebaseFirestore.instance.collection('popularCategories');
final categoriesRef = FirebaseFirestore.instance.collection('categories');
final locationsRef = FirebaseFirestore.instance.collection('locations');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final messagesRef = FirebaseFirestore.instance.collection('messages');
final activityFeedRef = FirebaseFirestore.instance.collection('feeds');
final hiresRef = FirebaseFirestore.instance.collection('hires');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final complaintRef = FirebaseFirestore.instance.collection('complaint');
AppUser currentUser;

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
  String professionalTitle;

  @override
  void initState() {
    super.initState();
    print("hello");
    pageController = PageController();
    // Detects when user signed in
    // logout();
    auth.authStateChanges().listen((User firebaseUser) {
      // Obtain the auth details from the request
      handleSignIn(firebaseUser);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    // (suppressErrors: false).then((account) {

    //   handleSignIn(account);
    // }).catchError((err) {
    //   print('Error signing in: $err');
    // });
  }

  Future<UserCredential> signInFirbaseAuthWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }

  handleSignIn(User firebaseUser) async {
    if (firebaseUser != null) {
      print('User is signed in!');
      print(firebaseUser.email);
      bool isSuccessful = await createUserInFirestore();
      if (isSuccessful == true) {
        setState(() {
          isAuth = true;
        });
        configurePushNotifications();
      }
    } else {
      print('User is currently signed out!');
      setState(() {
        isAuth = false;
      });
    }
  }

  configurePushNotifications() {
    // final GoogleSignInAccount user = googleSignIn.currentUser;
    if (Platform.isIOS) getiOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Messaging Token: $token\n");
      usersRef.doc(currentUser.uid).update({"androidNotificationToken": token});
    });

    _firebaseMessaging.configure(
      // onLaunch: (Map<String, dynamic> message) async {},
      // onResume: (Map<String, dynamic> message) async {},
      onMessage: (Map<String, dynamic> message) async {
        print("on message: $message\n");
        final String recipientId = message['data']['recipient'];
        final String body = message['notification']['body'];
        if (recipientId == currentUser.uid) {
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
    // 1) check if user exists in users collection in database (according to their uid)
    final User firebaseUser = auth.currentUser;
    print("firebaseUser.uid: ${firebaseUser.uid}");

    DocumentSnapshot doc = await usersRef.doc(firebaseUser.uid).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      isSuccessful = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateAccount(
                    firebaseUser: firebaseUser,
                  )));
      if (isSuccessful == true) {
        // 3) get username from create account, use it to make new user document in users collection
        doc = await usersRef.doc(firebaseUser.uid).get();
        currentUser = AppUser.fromDocument(doc);
      } else
        logout();
      return isSuccessful;
    }

    currentUser = AppUser.fromDocument(doc);
    return isSuccessful;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  logout() {
    auth.signOut();
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          ScreenOne(),
          ScreenTwo(),
          ScreenThree(),
          ScreenFour(),
          Profile(
            profileId: currentUser?.uid,
          ),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
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
            icon: Icon(OMIcons.category),
            activeIcon: Icon(Icons.category_rounded, size: 40.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(OMIcons.cardTravel),
            activeIcon: Icon(Icons.card_travel, size: 40.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(OMIcons.forum),
            activeIcon: Icon(Icons.forum, size: 40.0),
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
          image: DecorationImage(
              image: AssetImage("assets/images/freelancer.jpg"),
              fit: BoxFit.cover),
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
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: signInFirbaseAuthWithGoogle,
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
