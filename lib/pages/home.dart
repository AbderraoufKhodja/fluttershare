import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/authentication.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/pages/authentification_screen/create_account.dart';
import 'package:khadamat/pages/screen_five/profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khadamat/pages/screen_four/screen_four.dart';
import 'package:khadamat/pages/screen_one/screen_one.dart';
import 'package:khadamat/pages/screen_three/screen_three.dart';
import 'package:khadamat/pages/screen_two/screen_two.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef = FirebaseStorage.instance.ref();
final FirebaseAuth auth = FirebaseAuth.instance;
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final jobsRef = FirebaseFirestore.instance.collection('jobs');
final popularCategoriesRef = FirebaseFirestore.instance.collection('popularCategories');
final categoriesRef = FirebaseFirestore.instance.collection('categories');
final locationsRef = FirebaseFirestore.instance.collection('locations');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final messagesRef = FirebaseFirestore.instance.collection('messages');
final activityFeedRef = FirebaseFirestore.instance.collection('feeds');
final hiresRef = FirebaseFirestore.instance.collection('hires');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final complaintRef = FirebaseFirestore.instance.collection('complaint');
final forumRef = FirebaseFirestore.instance.collection('forum');
AppUser currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with RestorationMixin {
  final RestorableInt _selectedIndex = RestorableInt(0);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool isAuth = false;
  PageController pageController;
  bool isFreelancer = false;
  String category;
  String subCategory;
  String professionalTitle;

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

  @override
  String get restorationId => 'nav_rail';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selected_index');
  }

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

  handleSignIn(User firebaseUser) async {
    if (firebaseUser != null) {
      print('User is signed in!');
      print(firebaseUser.email);
      bool isSuccessful = await createUserInFirestore();
      if (isSuccessful == true) {
        setState(() {
          isAuth = true;
        });
        // TODO fix firebase_messaging
        // configurePushNotifications();
      }
    } else {
      print('User is currently signed out!');
      setState(() {
        isAuth = false;
      });
    }
  }
  // TODO fix firebase_messaging
  // configurePushNotifications() {
  //   // final GoogleSignInAccount user = googleSignIn.currentUser;
  //   if (Platform.isIOS) getiOSPermission();

  //   _firebaseMessaging.getToken().then((token) {
  //     print("Firebase Messaging Token: $token\n");
  //     usersRef
  //         .doc(currentUser.uid.value)
  //         .update({"androidNotificationToken": token});
  //   });

  //   _firebaseMessaging.configure(
  //     // onLaunch: (Map<String, dynamic> message) async {},
  //     // onResume: (Map<String, dynamic> message) async {},
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("on message: $message\n");
  //       final String recipientId = message['data']['recipient'];
  //       final String body = message['notification']['body'];
  //       if (recipientId == currentUser.uid.value) {
  //         print("Notification shown!");
  //         SnackBar snackbar = SnackBar(
  //             content: Text(
  //           body,
  //           overflow: TextOverflow.ellipsis,
  //         ));
  //         _scaffoldKey.currentState.showSnackBar(snackbar);
  //       }
  //       print("Notification NOT shown");
  //     },
  //   );
  // }

  // getiOSPermission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(alert: true, badge: true, sound: true));
  //   _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
  //     print("Settings registered: $settings");
  //   });
  // }

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
          ),
        ),
      );
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
      _selectedIndex.value = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          MediaQuery.of(context).orientation == Orientation.landscape
              ? buildNavigationRail()
              : Container(),
          buildPageView(),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).orientation != Orientation.landscape
          ? buildCupertinoTabBar()
          : null,
    );
  }

  CupertinoTabBar buildCupertinoTabBar() {
    return CupertinoTabBar(
      backgroundColor: Colors.white,
      inactiveColor: Theme.of(context).primaryColor,
      currentIndex: _selectedIndex.value,
      onTap: onTap,
      activeColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(OMIcons.whatshot),
          activeIcon: const Icon(Icons.whatshot, size: 40.0),
        ),
        BottomNavigationBarItem(
          icon: const Icon(OMIcons.cardTravel),
        ),
        BottomNavigationBarItem(
          icon: const Icon(OMIcons.cardTravel),
          activeIcon: const Icon(Icons.card_travel, size: 40.0),
        ),
        BottomNavigationBarItem(
          icon: const Icon(OMIcons.forum),
          activeIcon: const Icon(Icons.forum, size: 40.0),
        ),
        BottomNavigationBarItem(
          icon: const Icon(OMIcons.accountCircle),
          activeIcon: const Icon(Icons.account_circle, size: 40.0),
        ),
      ],
    );
  }

  Expanded buildPageView() {
    return Expanded(
      child: PageView(
        restorationId: restorationId,
        children: <Widget>[
          // ReplyApp(),
          ScreenOne(),
          // CreateFreelanceAccount(),
          ScreenTwo(),
          ScreenThree(),
          ScreenFour(),
          Profile(
            profileId: currentUser?.uid.value,
          ),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  NavigationRail buildNavigationRail() {
    return NavigationRail(
      // leading: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {},
      // ),
      elevation: 10,
      selectedIndex: _selectedIndex.value,
      groupAlignment: 0,
      onDestinationSelected: (index) {
        onTap(index);
        setState(() {
          _selectedIndex.value = index;
        });
      },
      labelType: NavigationRailLabelType.selected,
      destinations: [
        NavigationRailDestination(
          icon: const Icon(OMIcons.whatshot),
          selectedIcon: const Icon(Icons.whatshot, size: 40.0),
          label: Text(
            kFreelancers,
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(OMIcons.category),
          selectedIcon: const Icon(Icons.category_rounded, size: 40.0),
          label: Text(
            kJobs,
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(OMIcons.cardTravel),
          selectedIcon: const Icon(Icons.card_travel, size: 40.0),
          label: Text(
            kManageJob,
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(OMIcons.forum),
          selectedIcon: const Icon(Icons.forum, size: 40.0),
          label: Text(
            kForums,
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(OMIcons.accountCircle),
          selectedIcon: const Icon(Icons.account_circle, size: 40.0),
          label: Text(
            kProfile,
          ),
        ),
      ],
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage("assets/images/freelancer.jpg"), fit: BoxFit.fill),
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
            buildGoogleSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget buildGoogleSignInButton() {
    bool _isSigningIn = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User firebaseUser = await Authentication.signInWithGoogle(context: context);
                print('User is signed in!');
                print(firebaseUser.email);

                setState(() {
                  _isSigningIn = false;
                });

                if (firebaseUser != null) {
                  setState(() async {
                    bool isSuccessful = await createUserInFirestore();
                    if (isSuccessful == true) {
                      setState(() {
                        isAuth = true;
                      });
                      // TODO fix firebase_messaging
                      // configurePushNotifications();
                    }
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/images/google_signin_button.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
