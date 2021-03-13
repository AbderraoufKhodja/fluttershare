import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  GoogleMapPage({Key key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  String formattedAddress;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.7538, 3.0588),
    zoom: 14.4746,
  );

  GeoFirePoint geoFirePoint;
  GeoPoint geoPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: CircleAvatar(child: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: formattedAddress != null
                ? () => Navigator.pop(context, {
                      "formattedAddress": formattedAddress,
                      "geoFirePoint": geoFirePoint,
                    })
                : null,
            color: Colors.green,
            disabledColor: Colors.grey,
            icon: Icon(
              Icons.check,
              size: 50,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            cameraTargetBounds: CameraTargetBounds.unbounded,
            mapType: MapType.terrain,
            initialCameraPosition: _kGooglePlex,
            mapToolbarEnabled: true,
            compassEnabled: true,
            myLocationButtonEnabled: true,
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (LatLng position) => updateLocation(position),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              formattedAddress != null
                  ? Container(
                      margin: EdgeInsets.only(left: 2),
                      width: MediaQuery.of(context).size.width * 3.4 / 4,
                      child: Card(
                          child: ListTile(
                        title: Text(formattedAddress),
                      )))
                  : Container(),
              SizedBox(
                height: 30,
              ),
            ],
          )
        ],
      ),
    );
  }

  void updateLocation(LatLng position) {
    setState(() async {
      formattedAddress = null;
      _markers[MarkerId("my_location")] = Marker(
        markerId: MarkerId("my_location"),
        position: position,
      );
      geoFirePoint = GeoFirePoint(position.latitude, position.longitude);
      await EasyLoading.show(status: "Loading...");
      await updateAddress();
      await EasyLoading.dismiss(animation: true);
    });
  }

  Future<dynamic> updateAddress() {
    return placemarkFromCoordinates(
            geoFirePoint.latitude, geoFirePoint.longitude,
            localeIdentifier: "fr_")
        .then((value) {
      setState(() {
        formattedAddress = checkAddressField(str: value[0].street) +
            checkAddressField(str: value[0].subLocality) +
            checkAddressField(str: value[0].locality) +
            checkAddressField(str: value[0].subAdministrativeArea) +
            checkAddressField(str: value[0].administrativeArea) +
            checkAddressField(str: value[0].country, isLast: true);
      });
    });
  }
}

String checkAddressField({String str, bool isLast = false}) => str.isNotEmpty
    ? isLast
        ? str
        : str + ", "
    : "";

Future<Map> showGoogleMaps(context) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GoogleMapPage(),
    ),
  );
}
