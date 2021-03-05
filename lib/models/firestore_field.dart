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
    if (data[name].runtimeType != T) {
      print(
          "Type error: recieved ${data[name].runtimeType} type while $name is $T type");
      return FirestoreField(name: name, value: null);
    }
    if (name == "location") {
      dynamic appLocation = AppLocation.fromMap(data[name]);
      return FirestoreField(name: "location", value: appLocation);
    }
    return FirestoreField(name: name, value: data[name]);
  }
}
