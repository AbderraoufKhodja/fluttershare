import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

dynamic fieldGetter(
    {@required DocumentSnapshot document,
    @required String field,
    @required Type type}) {
  if (document.data().containsKey(field)) {
    if (document.data()[field].runtimeType == type)
      return document.data()[field];
    else
      print("Type error: $field");
    return null;
  } else {
    print("missing field: $field");
    return null;
  }
}
