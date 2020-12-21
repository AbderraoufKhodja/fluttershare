import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/create_client_account.dart';
import 'package:khadamat/pages/create_freelance_account.dart';
import 'package:khadamat/widgets/custom_button.dart';

class CreateAccount extends StatefulWidget {
  final FirebaseUser firebaseUser;
  CreateAccount({@required this.firebaseUser});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              padding: 5.0,
              heightFactor: 2,
              widthFactor: 2,
              function: () async {
                final isSuccessful = await showCreateClientAccount(context,
                    googleUser: widget.firebaseUser);
//                if (isSuccessful == true) {
//                  Navigator.pop(context, isSuccessful);
//                }
              },
              text: kCreateClientAccount,
              fillColor: Colors.blue,
            ),
            CustomButton(
              padding: 5.0,
              heightFactor: 2,
              widthFactor: 2,
              function: () async {
                final isSuccessful = await showCreateFreelanceAccount(context,
                    firebaseUser: widget.firebaseUser);
                if (isSuccessful == true) {
                  Navigator.pop(context, isSuccessful);
                }
              },
              text: kCreateFreelanceAccount,
              fillColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
