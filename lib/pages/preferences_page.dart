import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_button.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({Key key}) : super(key: key);

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  List<String> value = currentUser.preferences
      .map((preference) => preference.toString())
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListView(children: [
            ChipsChoice<String>.multiple(
              value: value,
              onChanged: (val) => setState(() => value = val),
              choiceItems: null,
              choiceLoader: getChoices,
              alignment: WrapAlignment.spaceAround,
              direction: Axis.horizontal,
              wrapped: true,
              choiceStyle: C2ChoiceStyle(
                labelStyle: TextStyle(fontSize: 15),
              ),
              choiceActiveStyle: C2ChoiceStyle(
                elevation: 10,
                color: Colors.red,
                borderWidth: 3,
                borderColor: Colors.red,
                labelStyle: TextStyle(fontSize: 18),
              ),
            ),
          ]),
        ),
        CustomButton(
          text: kConfirm,
          function: updatePreferances,
        )
      ],
    );
  }

  Future<List<C2Choice<String>>> getChoices() async {
    QuerySnapshot snapshot = await categoriesRef.get();
    return C2Choice.listFrom<String, dynamic>(
      source: snapshot.docs.map((doc) => doc.id).toList(),
      value: (index, item) => item,
      label: (index, item) => item,
      meta: (index, item) => item,
    );
  }

  updatePreferances() {
    usersRef.doc(currentUser.id).update({"preferences": value}).then(
        (val) => currentUser.preferences = value);
  }
}
