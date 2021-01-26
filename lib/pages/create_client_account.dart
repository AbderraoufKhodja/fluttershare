import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/header.dart';

class CreateClientAccount extends StatefulWidget {
  final FirebaseUser firebaseUser;
  CreateClientAccount({this.firebaseUser});
  @override
  _CreateClientAccountState createState() => _CreateClientAccountState();
}

class _CreateClientAccountState extends State<CreateClientAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;

  submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      usersRef.doc(widget.firebaseUser.uid).set({
        "id": widget.firebaseUser.uid,
        "googleName": widget.firebaseUser.displayName,
        "photoUrl": widget.firebaseUser.photoUrl,
        "email": widget.firebaseUser.email,
        "username": username,
        "isFreelancer": false,
        "createdAt": FieldValue.serverTimestamp(),
      }).then((value) {
        final SnackBar welcomeSnackbar =
            SnackBar(content: Text("Welcome $username!"));
        _scaffoldKey.currentState.showSnackBar(welcomeSnackbar);
        Timer(Duration(seconds: 1), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        });
      }, onError: (err) {
        _scaffoldKey.currentState.showSnackBar(kProblemSnackbar);
        print(err);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,
          titleText: "Set up your profile", implyBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "Create a username",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: buildForm(),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: TextFormField(
        validator: (val) {
          if (val.trim().length < 3 || val.isEmpty) {
            return "Username too short";
          } else if (val.trim().length > 12) {
            return "Username too long";
          } else {
            return null;
          }
        },
        onSaved: (val) => username = val,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Username",
          labelStyle: TextStyle(fontSize: 15.0),
          hintText: "Must be at least 3 characters",
        ),
      ),
    );
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }
}

Future<bool> showCreateClientAccount(BuildContext context,
    {@required FirebaseUser firebaseUser}) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CreateClientAccount(firebaseUser: firebaseUser),
    ),
  );
}
