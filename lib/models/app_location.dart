class AppLocation {
  final String address;
  final Map placemark;
  final Map geoFiredata;

  AppLocation({this.address, this.placemark, this.geoFiredata});
  factory AppLocation.fromMap(Map map) {
    return AppLocation(
      address: map["address"],
      geoFiredata: map["geoFirePoint"],
      placemark: map["placemark"],
    );
  }
}
