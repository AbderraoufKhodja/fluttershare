import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class UploadJob extends StatefulWidget {
  final User currentUser;

  UploadJob({this.currentUser});

  @override
  _UploadJobState createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob>
    with AutomaticKeepAliveClientMixin<UploadJob> {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController scheduleController = TextEditingController();

  File file;
  bool isUploading = false;
  String jobPostId = Uuid().v4();

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create JobPost"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera"), onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/images/upload.svg', height: 260.0),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "UploadJob Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
                color: Colors.deepOrange,
                onPressed: () => selectImage(context)),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$jobPostId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadJobImage(imageFile) async {
    StorageUploadTask uploadJobTask =
        storageRef.child("post_$jobPostId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadJobTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createJobPostInFirestore({
    String mediaUrl,
    String location,
    String description,
    String jobCategory,
    String price,
    String schedule,
  }) {
    jobPostsRef
        .document(widget.currentUser.id)
        .collection("userJobPosts")
        .document(jobPostId)
        .setData({
      "jobPostId": jobPostId,
      "jobCategory": jobCategory,
      "ownerId": widget.currentUser.id,
      "username": widget.currentUser.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "timestamp": timestamp,
      "price": price,
      "schedule": schedule,
      "marks": {},
      "isVacant": true,
      "isOnGoing": false,
      "isCompleted": false,
      "hiredId": {},
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    if (file != null) await compressImage();
    String mediaUrl = file == null ? "" : await uploadJobImage(file);
    createJobPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
      jobCategory: categoryController.text,
      price: priceController.text,
      schedule: scheduleController.text,
    );
    captionController.clear();
    locationController.clear();
    categoryController.clear();
    priceController.clear();
    scheduleController.clear();
    setState(() {
      file = null;
      isUploading = false;
      jobPostId = Uuid().v4();
    });
  }

  Scaffold buildUploadJobForm() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => null),
        title: Text(
          "Job form",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Divider(),
          isUploading ? linearProgress() : Text(""),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: Icon(
              Icons.work,
              color: Colors.grey,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: kJobDescription,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.grey,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: kJobLocation,
                  border: InputBorder.none,
                ),
              ),
            ),
            trailing: RaisedButton.icon(
              label: Text(
                "Location",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.blue,
              onPressed: getUserLocation,
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.category,
              color: Colors.grey,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  hintText: kCategoryLocation,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
//          Container(
//            width: 200.0,
//            height: 100.0,
//            alignment: Alignment.center,
//            child: RaisedButton.icon(
//              label: Text(
//                "Use Current Location",
//                style: TextStyle(color: Colors.white),
//              ),
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(30.0),
//              ),
//              color: Colors.blue,
//              onPressed: getUserLocation,
//              icon: Icon(
//                Icons.my_location,
//                color: Colors.white,
//              ),
//            ),
//          ),
          ListTile(
            leading: Icon(
              Icons.attach_money,
              color: Colors.grey,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: InputDecoration(
                  hintText: kCategoryLocation,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: file == null
                ? IconButton(
                    iconSize: 100.0,
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.grey,
                    ),
                    onPressed: () => selectImage(context),
                  )
                : Container(
                    height: 220.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(file),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildUploadJobForm();
//    return file == null ? buildSplashScreen() : buildUploadJobForm();
  }
}
