import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:khadamat/models/firestore_field.dart';

dynamic fieldGetter(
    {@required DocumentSnapshot document, @required FirestoreField field}) {
  Map<String, dynamic> data = document.data();
  if (data.containsKey(field.name)) {
    if (data[field.name].runtimeType == field.type)
      return data[field.name];
    else
      print("Type error: ${field.type}");
    return null;
  } else {
    print("missing field: ${field.name}");
    return null;
  }
}
