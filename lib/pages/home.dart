import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/create_account.dart';
import 'package:khadamat/pages/profile.dart';
import 'package:khadamat/pages/search.dart';
import 'package:khadamat/pages/upload.dart';

import 'activity_feed.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection("users");
final DateTime timeStamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error 1 signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error 2 signing in: $err');
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print('User signed in!: $account');
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageController(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  Widget buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
//          Timeline(),
          RaisedButton(
            child: Text(
              'Logout',
            ),
            onPressed: logout,
          ),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageController,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on,
              size: 40.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }

  buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.red.withOpacity(0.3),
              Colors.green.withOpacity(0.8),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Khadamat',
              style: TextStyle(
                fontFamily: 'Signatra',
                fontSize: 90.0,
                color: Colors.teal,
              ),
            ),
            GestureDetector(
              onTap: () {
                login();
                print('$widget onTap');
              },
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
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

  void onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void createUserInFirestore() async {
    // 1) check if user exists in users collection in database
    // (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      // 2) if user do not exist, then we want to take them to the create
      // account page
      final userName = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(),
        ),
      );
      // 3) get username from create account, use it to male new user document
      // in users collection
      usersRef.document(user.id).setData(
        {
          "id": user.id,
          "userName": userName,
          "photoUrl": user.photoUrl,
          "email": user.email,
          "displayName": user.displayName,
          "bio": "",
          "timeStamp": timeStamp,
        },
      );
      doc = await usersRef.document(user.id).get();
    }
    currentUser = User.fromDocument(doc);
  }
}