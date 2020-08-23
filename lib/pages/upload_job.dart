import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khadamat/categories.dart';
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
  // Todo initialize cat and subcat for firebase call
  String category;
  String subCategory;
  TextEditingController priceController = TextEditingController();
  TextEditingController scheduleController = TextEditingController();

  File file;
  bool isUploading = false;
  String jobId = Uuid().v4();

  int calIndex = 0;

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
          title: Text("Create Job"),
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
    final compressedImageFile = File('$path/img_$jobId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadJobImage(imageFile) async {
    StorageUploadTask uploadJobTask =
        storageRef.child("post_$jobId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadJobTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createJobInFirestore({
    String mediaUrl,
    String location,
    String description,
    String jobCategory,
    String jobSubCategory,
    String price,
    String schedule,
  }) {
    jobsRef.document(jobId).setData(
      {
        "jobId": jobId,
        "jobCategory": jobCategory,
        "jobSubCategory": jobSubCategory,
        "ownerId": widget.currentUser.id,
        "ownerName": widget.currentUser.username,
        "mediaUrl": mediaUrl,
        "description": description,
        "location": location,
        "timestamp": timestamp,
        "price": price,
        "schedule": schedule,
        "applications": {},
        "isVacant": true,
        "isOnGoing": false,
        "isCompleted": false,
        "hiredId": {},
      },
    );
    // TODO get back to widget.currentUser.id
    String id;
//    if (currentUser.id == "114724315703014253470") id = "105303619841718040097";
//    if (currentUser.id == "105303619841718040097") id = "114724315703014253470";
//    timelineRef.document(id).collection("timelineJobs").document(jobId).setData(
//      {
//        "jobId": jobId,
//        "jobCategory": jobCategory,
//        "ownerId": widget.currentUser.id,
//        "username": widget.currentUser.username,
//        "mediaUrl": mediaUrl,
//        "description": description,
//        "location": location,
//        "timestamp": timestamp,
//        "price": price,
//        "schedule": schedule,
//        "applications": {},
//        "isVacant": true,
//        "isOnGoing": false,
//        "isCompleted": false,
//        "hiredId": {},
//      },
//    );
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    if (file != null) await compressImage();
    String mediaUrl = file == null ? "" : await uploadJobImage(file);
    createJobInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
      jobCategory: category,
      jobSubCategory: subCategory,
      price: priceController.text,
      schedule: scheduleController.text,
    );
    captionController.clear();
    locationController.clear();
    priceController.clear();
    scheduleController.clear();
    setState(() {
      file = null;
      isUploading = false;
      jobId = Uuid().v4();
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
              color: Theme.of(context).primaryColor,
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
              color: Theme.of(context).primaryColor,
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
            leading: Text(
              "Category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
            title: DropdownButton<String>(
                value: this.category,
                icon: Container(
                  child: Icon(Icons.arrow_downward),
                ),
                iconSize: 24,
                elevation: 16,
                isExpanded: true,
                style: TextStyle(color: Colors.blueAccent),
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.grey,
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (String val) {
                  setState(() {
                    this.category = val;
                    calIndex = categoryList.indexOf(val);
                  });
                },
                items: categoryList
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ))
                    .toList()),
          ),
          ListTile(
            leading: Text(
              "Subcategory",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textBaseline: TextBaseline.alphabetic,
              ),
              textAlign: TextAlign.start,
            ),
            title: DropdownButton<String>(
                value: this.subCategory,
                icon: Container(
                  child: Icon(Icons.arrow_downward),
                ),
                iconSize: 24,
                elevation: 16,
                isExpanded: true,
                style: TextStyle(color: Colors.blueAccent),
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.grey,
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
                ),
                onChanged: (String val) {
                  setState(() {
                    this.subCategory = val;
                  });
                },
                items: subCategoryList[calIndex]
                    .map((subCategory) => DropdownMenuItem(
                          value: subCategory,
                          child: Text(
                            subCategory,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ))
                    .toList()),
          ),
          ListTile(
            leading: Icon(
              Icons.attach_money,
              color: Theme.of(context).primaryColor,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: InputDecoration(
                  hintText: kCategory,
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
                      color: Theme.of(context).primaryColor,
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
