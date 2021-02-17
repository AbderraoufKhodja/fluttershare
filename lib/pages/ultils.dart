import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

FlutterMap flutterMap(BuildContext context) {
  return FlutterMap(
    options: MapOptions(
      bounds: LatLngBounds(LatLng(58.8, 6.1), LatLng(59, 6.2)),
      boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(8.0)),
    ),
    layers: [
      TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c']),
      MarkerLayerOptions(
        markers: [
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(51.5, -0.09),
            builder: (context) => Container(
              child: FlutterLogo(),
            ),
          ),
        ],
      ),
    ],
  );
}

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
