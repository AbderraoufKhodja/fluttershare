class AppLocation {
  final String address;
  final Map geoFiredata;

  AppLocation({this.address, this.geoFiredata});
  factory AppLocation.fromMap(Map map) {
    return AppLocation(
      address: map["address"],
      geoFiredata: map["geoFirePoint"],
    );
  }
}
