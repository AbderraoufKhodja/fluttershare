import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/locations.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_text_form_field.dart';
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
  TextEditingController professionalCategoryController =
      TextEditingController();
  String category;
  List<String> categoriesList = [""];
  List<String> subCategoriesList = [""];
  String subCategory;
  String country = kCountry;
  String administrativeArea;
  String subAdministrativeArea;
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
  final _formKey = GlobalKey<FormState>();

  File file;
  bool isUploading = false;
  int valIndex = 0;
  String instruction = kTellUsAboutYou;
  DateTime birthDate;

  bool get wantKeepAlive => true;
  get user =>
      widget.googleUser != null ? widget.googleUser : widget.firestoreUser;

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: null),
        title: Text(
          kProfessionalInfo,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              kSubmit,
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            isUploading ? linearProgress() : Text(""),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(instruction)),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
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
                          CustomTextFormField(
                            validator: (text) =>
                                checkLength(text, label: kPersonelBio),
                            controller: usernameController,
                            hint: kUsername,
                            onTap: () =>
                                updateInstruction(kUsernameInstruction),
                          ),
                          CustomTextFormField(
                              validator: (text) =>
                                  checkLength(text, label: kPersonelBio),
                              controller: professionalTitleController,
                              hint: kProfessionalTitle,
                              onTap: () => updateInstruction(
                                  kProfessionalTitleInstruction)),
                          CustomTextFormField(
                              validator: (text) =>
                                  checkLength(text, label: kPersonelBio),
                              controller: personalBioController,
                              hint: kPersonelBio,
                              onTap: () =>
                                  updateInstruction(kPersonalBioInstruction)),
                          CustomTextFormField(
                              validator: (text) =>
                                  checkLength(text, label: kLocation),
                              controller: locationController,
                              hint: kLocation,
                              readOnly: true,
                              trailing: buildLocationButton(),
                              onTap: () async {
                                updateInstruction(kLocationInstruction);
                                await showLocationList(context);
                              }),
                          CustomTextFormField(
                              validator: (text) => checkLength(text,
                                  label: kBirthDateController),
                              controller: birthDateController,
                              hint: kBirthDateController,
                              trailing: buildBirthDateGestureDetector(),
                              readOnly: true,
                              onTap: () {
                                updateInstruction(kBirthDateInstruction);
                                showCalender();
                              }),
                          CustomTextFormField(
                              validator: (text) =>
                                  checkLength(text, label: kGenderController),
                              controller: genderController,
                              hint: kGenderController,
                              readOnly: true,
                              onTap: () {
                                updateInstruction(kGenderInstruction);
                                selectGender(context);
                              }),
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
                          CustomTextFormField(
                              validator: (text) => checkLength(text,
                                  label: kProfessionalDescription),
                              controller: professionalDescriptionController,
                              hint: kProfessionalDescription,
                              onTap: () => updateInstruction(
                                  kProfessionalDescriptionInstruction)),
                          CustomTextFormField(
                              readOnly: true,
                              style: TextStyle(height: 1.5),
                              validator: (text) => checkLength(text,
                                  label: kProfessionalCategoryController),
                              controller: professionalCategoryController,
                              hint: kProfessionalCategoryController,
                              onTap: () async {
                                updateInstruction(
                                    kProfessionalCategoryInstruction);
                                await showCategoryList(context);
                              }),
                          Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                CustomTextFormField(
                                    validator: (text) =>
                                        checkLength(text, label: kKeyWords),
                                    controller: keyWord1Controller,
                                    hint: "$kKeyWords 1",
                                    onTap: () => updateInstruction(
                                        kKeyWordsInstruction)),
                                CustomTextFormField(
                                    validator: (text) =>
                                        checkLength(text, label: kKeyWords),
                                    controller: keyWord2Controller,
                                    hint: "$kKeyWords 2",
                                    onTap: () => updateInstruction(
                                        kKeyWordsInstruction)),
                                CustomTextFormField(
                                    validator: (text) =>
                                        checkLength(text, label: kKeyWords),
                                    controller: keyWord3Controller,
                                    hint: "$kKeyWords 3",
                                    onTap: () => updateInstruction(
                                        kKeyWordsInstruction)),
                                CustomTextFormField(
                                    validator: (text) =>
                                        checkLength(text, label: kKeyWords),
                                    controller: keyWord4Controller,
                                    hint: "$kKeyWords 4",
                                    onTap: () => updateInstruction(
                                        kKeyWordsInstruction)),
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
                          CustomTextFormField(
                            controller: diplomaController,
                            hint: kDiploma,
                            onTap: () => updateInstruction(kDiplomaInstruction),
                          ),
                          CustomTextFormField(
                              controller: licenceController,
                              hint: kLicence,
                              onTap: () =>
                                  updateInstruction(kLicenceInstruction)),
                          CustomTextFormField(
                              controller: certificationController,
                              hint: kCertification,
                              onTap: () =>
                                  updateInstruction(kCertificationInstruction)),
                          CustomTextFormField(
                              controller: languageController,
                              hint: kLanguage,
                              onTap: () =>
                                  updateInstruction(kLanguageInstruction)),
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
                          CustomTextFormField(
                              controller: experienceController,
                              hint: kExperience,
                              onTap: () =>
                                  updateInstruction(kExperienceInstruction)),
                          CustomTextFormField(
                              controller: internshipController,
                              hint: kInternship,
                              onTap: () =>
                                  updateInstruction(kInternshipInstruction)),
                          CustomTextFormField(
                              controller: competenceController,
                              hint: kCompetences,
                              onTap: () =>
                                  updateInstruction(kCompetencesInstruction)),
                          CustomTextFormField(
                              controller: achievementController,
                              hint: kAchievement,
                              onTap: () =>
                                  updateInstruction(kAchievementInstruction)),
                          CustomTextFormField(
                              controller: recommendationController,
                              hint: kRecommendation,
                              onTap: () => updateInstruction(
                                  kRecommendationInstruction)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String checkLength(value,
      {@required String label, int min = 3, int max = 1000}) {
    print(value.isEmpty);
    print(value.trim().length < min);
    if (value.trim().length < min || value.isEmpty) {
      return "$label too short";
    } else if (value.trim().length > max) {
      return "$label too long";
    } else {
      return null;
    }
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
      "professionalDescription": professionalDescriptionController.text,
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

  handleSubmit() async {
    final form = _formKey.currentState;
    print("form.validate() ;${form.validate()}");
    form.save();
    if ((form.validate())) {
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
  }

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

  selectGender(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              child: Text(kMale),
              onPressed: () {
                setState(() {
                  genderController.text = kMale;
                  Navigator.pop(context);
                });
              },
            ),
            SimpleDialogOption(
              child: Text(kFemale),
              onPressed: () {
                setState(() {
                  genderController.text = kFemale;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  showLocationList(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: Text(kSelectLocation),
            children: <Widget>[
              buildTwoDependantDropdownLocationMenu(setState),
              SimpleDialogOption(
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      },
    );
  }

  showCategoryList(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: StatefulBuilder(
            builder: (context, setState) => SimpleDialog(
              title: Text(kSelectLocation),
              children: <Widget>[
                buildTwoDependantDropdownCategoryMenu(context, setState),
                SimpleDialogOption(
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      },
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
    birthDateController.clear();
    genderController.clear();
    keyWord1Controller.clear();
    keyWord2Controller.clear();
    keyWord3Controller.clear();
    keyWord4Controller.clear();
  }

  buildBirthDateGestureDetector() {
    return GestureDetector(
        child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: new Icon(
              Icons.calendar_today,
              color: Colors.white,
            )),
        onTap: showCalender);
  }

  showCalender() async {
    final datePick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime(2100));
    if (datePick != null && datePick != birthDate) {
      setState(() {
        birthDate = datePick;
        birthDateController.text =
            "${birthDate.day}/${birthDate.month}/${birthDate.year}"; // 08/14/2019
      });
    }
  }

  buildTwoDependantDropdownCategoryMenu(
      BuildContext context, StateSetter setState) {
    return Column(
      children: [
        buildListTile(
          setState,
          onChanged: (String val) {
            setState(() {
              subCategory = null;
              category = val;
              professionalCategoryController.text =
                  "$category\n    ➤${subCategory == null ? "" : subCategory}";
              getSubCategoryList(setState);
            });
          },
          value: category,
          items: categoriesList,
        ),
        buildListTile(
          setState,
          value: subCategory,
          onChanged: (String value) {
            setState(() {
              subCategory = value;
              professionalCategoryController.text =
                  "$category\n    ➤$subCategory";
            });
          },
          items: subCategoriesList,
          onIconPressed: () => showInputBottomSheet(context),
        ),
      ],
    );
  }

  PersistentBottomSheetController showInputBottomSheet(BuildContext context) {
    return Scaffold.of(context).showBottomSheet(
      (BuildContext context) => Container(
        height: 200.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            )),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  ListTile buildListTile(StateSetter setState,
      {Function(String val) onChanged,
      String value,
      List<String> items,
      Function onIconPressed}) {
    return ListTile(
      title: DropdownButton<String>(
          value: value,
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
            color: Colors.grey,
          ),
          onChanged: onChanged,
          items: items
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
      trailing: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: onIconPressed,
        ),
      ),
    );
  }

  buildTwoDependantDropdownLocationMenu(StateSetter setState) {
    return Column(
      children: [
        buildListTile(
          setState,
          value: administrativeArea,
          onChanged: (String val) {
            setState(() {
              subAdministrativeArea = null;
              administrativeArea = val;
              valIndex = provinceLatinNameList.indexOf(val);
            });
          },
          items: provinceLatinNameList,
        ),
        buildListTile(
          setState,
          value: subAdministrativeArea,
          onChanged: (String value) {
            setState(() {
              subAdministrativeArea = value;
              locationController.text =
                  "$subAdministrativeArea, $administrativeArea, $country";
            });
          },
          items: communeLatinNameList[valIndex],
        ),
      ],
    );
  }

  GestureDetector buildLocationButton() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
      onTap: getUserLocation,
    );
  }

  getUserLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress =
        " ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}";
    locationController.text = formattedAddress;
  }

  updateInstruction(String instruction) {
    setState(() {
      this.instruction = instruction;
    });
  }

  getCategoryList() async {
    QuerySnapshot snapshot = await categoriesRef.getDocuments();
    setState(() {
      categoriesList = snapshot.documents.map((doc) => doc.documentID).toList();
      subCategoriesList = [""];
    });
  }

  getSubCategoryList(StateSetter setState) async {
    QuerySnapshot snapshot = await categoriesRef
        .document(category)
        .collection("subCategories")
        .getDocuments();
    setState(() {
      subCategoriesList =
          snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  getCountryList() async {
    QuerySnapshot snapshot = await categoriesRef.getDocuments();
    setState(() {
      categoriesList = snapshot.documents.map((doc) => doc.documentID).toList();
      subCategoriesList = [""];
    });
  }

  getAdministrativeAreList(StateSetter setState) async {
    QuerySnapshot snapshot = await categoriesRef
        .document(category)
        .collection("subCategories")
        .getDocuments();
    setState(() {
      subCategoriesList =
          snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  getSubAdministrativeAreList(StateSetter setState) async {
    QuerySnapshot snapshot = await categoriesRef
        .document(category)
        .collection("subCategories")
        .getDocuments();
    setState(() {
      subCategoriesList =
          snapshot.documents.map((doc) => doc.documentID).toList();
    });
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
