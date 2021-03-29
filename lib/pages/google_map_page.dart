import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
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
  GeoCode geoCode = GeoCode(apiKey: "690695374351251687867x94033");

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.7538, 3.0588),
    zoom: 14.4746,
  );

  GeoFirePoint geoFirePoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: CircleAvatar(child: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: formattedAddress != null && geoFirePoint != null
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
      extendBodyBehindAppBar: false,
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
      await EasyLoading.show(status: "Loading...", dismissOnTap: true);
      await updateAddress();
      await EasyLoading.dismiss(animation: true);
      await EasyLoading.showSuccess("done");
    });
  }

  Future<void> updateAddress() {
    try {
      if (kIsWeb)
        return geoCode
            .reverseGeocoding(latitude: geoFirePoint.latitude, longitude: geoFirePoint.longitude)
            .then((address) {
          setState(() {
            formattedAddress = checkAddressField(str: address.streetAddress) +
                checkAddressField(str: address.city) +
                checkAddressField(str: address.region) +
                checkAddressField(str: address.countryName) +
                checkAddressField(str: address.countryCode, isLast: true);
          });
        });
      else
        return placemarkFromCoordinates(geoFirePoint.latitude, geoFirePoint.longitude,
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
    } catch (e) {
      print(e);
    }
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
