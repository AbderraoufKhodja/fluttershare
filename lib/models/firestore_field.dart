import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khadamat/models/app_location.dart';

class FirestoreField<T> {
  final String name;
  T value;

  FirestoreField({
    this.value,
    this.name,
  });

  factory FirestoreField.fromDocument({String name, DocumentSnapshot doc}) {
    if (!doc.exists) {
      print("$name: document does not exists");
      return FirestoreField(name: name, value: null);
    }
    Map<String, dynamic> data = doc.data();
    if (!data.containsKey(name)) {
      print("missing field: $name");
      return FirestoreField(name: name, value: null);
    }
    final field = data[name];
    if (field.runtimeType == Null) {
      print("$name is null");
      return FirestoreField(name: name, value: null);
    }
    if (field.runtimeType == int && T == double) {
      return FirestoreField(name: name, value: data[name].toDouble());
    }
    if (field.runtimeType == data.runtimeType) {
      return FirestoreField(name: name, value: field);
    }
    // if (name == "location") {
    //   dynamic appLocation = AppLocation.fromMap(field);
    //   return FirestoreField(name: "location", value: appLocation);
    // }
    if (field.runtimeType != T) {
      print("Type error: recieved ${field.runtimeType} type while $name is $T type");
      return FirestoreField(name: name, value: null);
    }
    return FirestoreField(name: name, value: field);
  }
}
