import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khadamat/categories.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class CreateFreelanceAccount extends StatefulWidget {
  final User firestoreUser;
  final GoogleSignInAccount googleUser;

  CreateFreelanceAccount({this.firestoreUser, this.googleUser});

  @override
  _CreateFreelanceAccountState createState() => _CreateFreelanceAccountState();
}

class _CreateFreelanceAccountState extends State<CreateFreelanceAccount>
    with AutomaticKeepAliveClientMixin<CreateFreelanceAccount> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController professionalTitleController = TextEditingController();
  TextEditingController personalBioController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController professionalDescriptionController =
      TextEditingController();
  String category;
  String subCategory;
  TextEditingController keyWord1Controller = TextEditingController();
  TextEditingController keyWord2Controller = TextEditingController();
  TextEditingController keyWord3Controller = TextEditingController();
  TextEditingController keyWord4Controller = TextEditingController();
  TextEditingController internshipController = TextEditingController();
  TextEditingController diplomaController = TextEditingController();
  TextEditingController licenceController = TextEditingController();
  TextEditingController certificationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController competenceController = TextEditingController();
  TextEditingController achievementController = TextEditingController();
  TextEditingController recommendationController = TextEditingController();
  TextEditingController languageController = TextEditingController();

  File file;
  bool isUploading = false;
  int calIndex = 0;
  String instruction = kTellUsAboutYou;
  String initValue = "Select your Birth Date";
  bool isDateSelected = false;
  DateTime birthDate; //

  get user =>
      widget.googleUser != null ? widget.googleUser : widget.firestoreUser;

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
          title: Text(kUploadImage),
          children: <Widget>[
            SimpleDialogOption(
                child: Text(kFromCamera), onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text(kFromGallery), onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text(kCancel),
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
                  "UploadCard Image",
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
    final compressedImageFile = File('$path/img_${user.id}.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadCardTask =
        storageRef.child("card_${user.id}.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadCardTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    if (file != null) await compressImage();
    String mediaUrl = file == null ? "" : await uploadImage(file);
    uploadUsersProfessionalInfo(mediaUrl);
    clearControllers();
    clearImage();
    setState(() {
      isUploading = false;
    });
    Navigator.pop(context, true);
  }

  uploadUsersProfessionalInfo(String mediaUrl) {
    usersRef.document(user.id).setData({
      "id": user.id,
      "displayName": user.displayName,
      "photoUrl": user.photoUrl,
      "email": user.email,
      "isFreelancer": true,
      "mediaUrl": mediaUrl,
      "username": usernameController.text,
      "ProfessionalTitle": professionalTitleController.text,
      "personalBio": personalBioController.text,
      "location": locationController.text,
      "birthDate": birthDateController.text,
      "gender": genderController.text,
      "professionalDescriptionDescription":
          professionalDescriptionController.text,
      "keyWords": "$keyWord1Controller;$keyWord2Controller;"
          "$keyWord3Controller;$keyWord4Controller;",
      "category": category,
      "subCategory": subCategory,
      "diploma": diplomaController.text,
      "licence": licenceController.text,
      "certification": certificationController.text,
      "language": languageController.text,
      "experience": experienceController.text,
      "internship": internshipController.text,
      "competence": competenceController.text,
      "achievement": achievementController.text,
      "recommendation": recommendationController.text,
      "claps": {},
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  clearControllers() {
    usernameController.clear();
    professionalTitleController.clear();
    personalBioController.clear();
    locationController.clear();
    professionalDescriptionController.clear();
    internshipController.clear();
    diplomaController.clear();
    licenceController.clear();
    certificationController.clear();
    experienceController.clear();
    competenceController.clear();
    achievementController.clear();
    recommendationController.clear();
    languageController.clear();
  }

  Scaffold buildUploadCardForm() {
    return Scaffold(
      backgroundColor: Colors.white,
//      floatingActionButton: FloatingActionButton(),
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: null),
//        title: Text(
//          kProfessionalInfo,
//          style: TextStyle(color: Colors.black),
//        ),
//        actions: [
//          FlatButton(
//            onPressed: isUploading ? null : () => handleSubmit(),
//            child: Text(
//              kSubmit,
//              style: TextStyle(
//                color: Colors.blueAccent,
//                fontWeight: FontWeight.bold,
//                fontSize: 20.0,
//              ),
//            ),
//          ),
//        ],
//      ),
      body: Column(
        children: [
          isUploading ? linearProgress() : Text(""),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(instruction)),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: file == null
                    ? GestureDetector(
                        onTap: () => selectImage(context),
                        child: CircleAvatar(
                          radius: 50.0,
                          child: Icon(
                            Icons.add_a_photo,
                            size: 50.0,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 50.0,
                        backgroundImage: FileImage(file),
                      ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 5.0, left: 5.0, top: 15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  color: Colors.blueGrey),
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: usernameController,
                          hint: kUsername,
                          onTap: () => updateInstruction(kUsername),
                        ),
                        CustomTextField(
                            controller: professionalTitleController,
                            hint: kProfessionalTitle,
                            onTap: () => updateInstruction(kProfessionalTitle)),
                        CustomTextField(
                            controller: personalBioController,
                            hint: kBio,
                            onTap: () => updateInstruction(kBio)),
                        CustomTextField(
                            controller: locationController,
                            hint: kLocation,
                            trailing: buildLocationButton(),
                            onTap: () => updateInstruction(kLocation)),
                        CustomTextField(
                            controller: birthDateController,
                            hint: kBirthDateController,
                            trailing: buildBirthDayGestureDetector(),
                            onTap: () =>
                                updateInstruction(kBirthDateController)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                            controller: professionalDescriptionController,
                            hint: kProfessionalDescription,
                            onTap: () =>
                                updateInstruction(kProfessionalDescription)),
                        buildCategoryListTile(),
                        buildSubCategoryListTile(),
                        Container(
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                  controller: keyWord1Controller,
                                  hint: "$kKeyWords 1",
                                  onTap: () => updateInstruction(kKeyWords)),
                              CustomTextField(
                                  controller: keyWord2Controller,
                                  hint: "$kKeyWords 2",
                                  onTap: () => updateInstruction(kKeyWords)),
                              CustomTextField(
                                  controller: keyWord3Controller,
                                  hint: "$kKeyWords 3",
                                  onTap: () => updateInstruction(kKeyWords)),
                              CustomTextField(
                                  controller: keyWord4Controller,
                                  hint: "$kKeyWords 4",
                                  onTap: () => updateInstruction(kKeyWords)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                            controller: diplomaController,
                            hint: kDiploma,
                            onTap: () => updateInstruction(kDiploma)),
                        CustomTextField(
                            controller: licenceController,
                            hint: kLicence,
                            onTap: () => updateInstruction(kLicence)),
                        CustomTextField(
                            controller: certificationController,
                            hint: kCertification,
                            onTap: () => updateInstruction(kCertification)),
                        CustomTextField(
                            controller: languageController,
                            hint: kLanguage,
                            onTap: () => updateInstruction(kLanguage)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                            controller: experienceController,
                            hint: kExperience,
                            onTap: () => updateInstruction(kExperience)),
                        CustomTextField(
                            controller: internshipController,
                            hint: kInternship,
                            onTap: () => updateInstruction(kInternship)),
                        CustomTextField(
                            controller: competenceController,
                            hint: kCompetences,
                            onTap: () => updateInstruction(kCompetences)),
                        CustomTextField(
                            controller: achievementController,
                            hint: kAchievement,
                            onTap: () => updateInstruction(kAchievement)),
                        CustomTextField(
                            controller: recommendationController,
                            hint: kRecommendation,
                            onTap: () => updateInstruction(kRecommendation)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBirthDayGestureDetector() {
    return GestureDetector(
        child: new Icon(Icons.calendar_today),
        onTap: () async {
          final datePick = await showDatePicker(
              context: context,
              initialDate: new DateTime.now(),
              firstDate: new DateTime(1900),
              lastDate: new DateTime(2100));
          if (datePick != null && datePick != birthDate) {
            setState(() {
              birthDate = datePick;
              isDateSelected = true;
              birthDateController.text =
                  "${birthDate.month}/${birthDate.day}/${birthDate.year}"; // 08/14/2019
            });
          }
        });
  }

  ListTile buildSubCategoryListTile() {
    return ListTile(
      title: DropdownButton<String>(
          value: this.subCategory,
          icon: Container(
            child: Icon(Icons.list),
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
                      maxLines: 2,
                    ),
                  ))
              .toList()),
    );
  }

  ListTile buildCategoryListTile() {
    return ListTile(
      title: DropdownButton<String>(
          value: this.category,
          icon: Container(
            child: Icon(Icons.list),
          ),
          iconSize: 24,
          elevation: 16,
          isExpanded: true,
          style: TextStyle(color: Colors.grey),
          iconDisabledColor: Colors.black,
          iconEnabledColor: Colors.grey,
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
          ),
          onChanged: (String val) {
            setState(() {
              this.subCategory = null;
              this.category = val;
              calIndex = categoryList.indexOf(val);
            });
          },
          items: categoryList
              .map(
                (category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              )
              .toList()),
    );
  }

  GestureDetector buildLocationButton() {
    return GestureDetector(
      child: Icon(Icons.my_location),
      onTap: getUserLocation,
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
    return buildUploadCardForm();
//    return file == null ? buildSplashScreen() : buildUploadCardForm();
  }

  updateInstruction(String instruction) {
    setState(() {
      this.instruction = instruction;
    });
  }
}

class CustomTextField extends StatelessWidget {
  final Widget trailing;
  final TextEditingController controller;
  final String hint;
  final Function onTap;

  CustomTextField({
    @required this.controller,
    @required this.hint,
    this.trailing = const Text(""),
    this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        ListTile(
          title: Container(
            width: 250.0,
            child: TextField(
              onTap: onTap,
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
          trailing: trailing,
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }
}

Future<bool> showCreateFreelanceAccount(BuildContext context,
    {GoogleSignInAccount googleUser, User firestoreUser}) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CreateFreelanceAccount(
        googleUser: googleUser,
        firestoreUser: firestoreUser,
      ),
    ),
  );
}
