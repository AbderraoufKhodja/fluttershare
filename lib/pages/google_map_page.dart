import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/activity_feed.dart';

class GoogleMapPage extends StatefulWidget {
  GoogleMapPage({Key key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  String title;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.7538, 3.0588),
    zoom: 14.4746,
  );

  GeoFirePoint geoFirePoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ""),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
              cameraTargetBounds: CameraTargetBounds.unbounded,
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraIdle: updateAddressTitle,
              onTap: (LatLng position) => updateGeoFirePoint(position)),
          Center(
              child: Icon(
            Icons.place,
            color: Colors.red[700],
            size: 50,
          )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await updateAddressTitle();
          if (geoFirePoint != null || title != null)
            Navigator.pop(
                context, {"geoFirePoint": geoFirePoint, "address": title});
          else
            Navigator.pop(context);
        },
        label: Text(kSelectLocation),
        icon: Icon(Icons.place),
      ),
    );
  }

  void updateGeoFirePoint(LatLng position) {
    setState(() {
      title = null;
      geoFirePoint = GeoFirePoint(position.latitude, position.longitude);
    });
  }

  Future<dynamic> updateAddressTitle() {
    return placemarkFromCoordinates(
            geoFirePoint.latitude, geoFirePoint.longitude)
        .then((value) {
      setState(() {
        title = value[0].country +
            ", " +
            value[0].administrativeArea +
            ", " +
            value[0].subAdministrativeArea +
            ", " +
            value[0].locality;
      });
    });
  }
}

Future<Map> showGoogleMaps(context) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GoogleMapPage(),
    ),
  );
}
