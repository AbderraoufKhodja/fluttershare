import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khadamat/constants.dart';
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
  TextEditingController personalBioController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController professionalDescriptionController =
      TextEditingController();
  TextEditingController professionalCategoryController =
      TextEditingController();
  TextEditingController professionalTitleController = TextEditingController();
  String professionalCategory;
  String professionalTitle;
  List<String> professionalCategoriesList = [""];
  List<String> professionalTitlesList = [""];
  String country;
  String administrativeArea;
  String subAdministrativeArea;
  List<String> countriesList = [""];
  List<String> administrativeAreasList = [""];
  List<String> subAdministrativeAreasList = [""];
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
  final _categoryScaffoldKey = GlobalKey<ScaffoldState>();

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
    getCategoriesList();
    getCountriesList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white70,
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
                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    color: Colors.white),
                child: ListView(
                  children: <Widget>[
                    CustomTextFormField(
                      validator: (text) =>
                          checkLength(text, label: kPersonalBio),
                      controller: usernameController,
                      hint: kUsername,
                      onTap: () => updateInstruction(kUsernameInstruction),
                    ),
                    CustomTextFormField(
                        validator: (text) =>
                            checkLength(text, label: kPersonalBio),
                        controller: personalBioController,
                        hint: kPersonalBio,
                        onTap: () =>
                            updateInstruction(kPersonalBioInstruction)),
                    CustomTextFormField(
                        validator: (text) =>
                            checkLocationAddress(text, label: kLocation),
                        controller: locationController,
                        hint: kLocation,
                        readOnly: true,
                        trailing: buildLocationButton(),
                        onTap: () async {
                          updateInstruction(kLocationInstruction);
                          await showLocationList(context);
                        }),
                    CustomTextFormField(
                        validator: (text) =>
                            checkLength(text, label: kBirthDateController),
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
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                              readOnly: true,
                              validator: (text) => checkLength(text,
                                  label: kProfessionalCategoryController),
                              controller: professionalCategoryController,
                              hint: kProfessionalCategoryController,
                              onTap: () async {
                                updateInstruction(
                                    kProfessionalCategoryInstruction);
                                await showCategoryList(context);
                              }),
                        ),
                        Container(
                          height: 30,
                          child: VerticalDivider(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: CustomTextFormField(
                              readOnly: true,
                              validator: (text) =>
                                  checkLength(text, label: kProfessionalTitle),
                              controller: professionalTitleController,
                              hint: kProfessionalTitleHint,
                              onTap: () async {
                                updateInstruction(
                                    kProfessionalTitleInstruction);
                                await showCategoryList(context);
                              }),
                        ),
                      ],
                    ),
                    CustomTextFormField(
                        validator: (text) =>
                            checkLength(text, label: kProfessionalDescription),
                        controller: professionalDescriptionController,
                        hint: kProfessionalDescription,
                        onTap: () => updateInstruction(
                            kProfessionalDescriptionInstruction)),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                              validator: (text) =>
                                  checkLength(text, label: kKeyWords),
                              controller: keyWord1Controller,
                              hint: "$kKeyWords 1",
                              onTap: () =>
                                  updateInstruction(kKeyWordsInstruction)),
                        ),
                        Container(
                          height: 30,
                          child: VerticalDivider(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: CustomTextFormField(
                              validator: (text) =>
                                  checkLength(text, label: kKeyWords),
                              controller: keyWord2Controller,
                              hint: "$kKeyWords 2",
                              onTap: () =>
                                  updateInstruction(kKeyWordsInstruction)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                              validator: (text) =>
                                  checkLength(text, label: kKeyWords),
                              controller: keyWord3Controller,
                              hint: "$kKeyWords 3",
                              onTap: () =>
                                  updateInstruction(kKeyWordsInstruction)),
                        ),
                        Container(
                          height: 30,
                          child: VerticalDivider(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: CustomTextFormField(
                              validator: (text) =>
                                  checkLength(text, label: kKeyWords),
                              controller: keyWord4Controller,
                              hint: "$kKeyWords 4",
                              onTap: () =>
                                  updateInstruction(kKeyWordsInstruction)),
                        ),
                      ],
                    ),
                    CustomTextFormField(
                      controller: diplomaController,
                      hint: kDiploma,
                      onTap: () => updateInstruction(kDiplomaInstruction),
                    ),
                    CustomTextFormField(
                        controller: licenceController,
                        hint: kLicence,
                        onTap: () => updateInstruction(kLicenceInstruction)),
                    CustomTextFormField(
                        controller: certificationController,
                        hint: kCertification,
                        onTap: () =>
                            updateInstruction(kCertificationInstruction)),
                    CustomTextFormField(
                        controller: languageController,
                        hint: kLanguage,
                        onTap: () => updateInstruction(kLanguageInstruction)),
                    CustomTextFormField(
                        controller: experienceController,
                        hint: kExperience,
                        onTap: () => updateInstruction(kExperienceInstruction)),
                    CustomTextFormField(
                        controller: internshipController,
                        hint: kInternship,
                        onTap: () => updateInstruction(kInternshipInstruction)),
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
                        onTap: () =>
                            updateInstruction(kRecommendationInstruction)),
                    GestureDetector(
                      onTap: isUploading ? null : () => handleSubmit(),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        height: 50.0,
                        width: 350.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
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
      {@required String label, int min = 2, int max = 1000}) {
    if (value.trim().length < min || value.isEmpty) {
      return "$label $kTooShort";
    } else if (value.trim().length > max) {
      return "$label $kTooLong";
    } else {
      return null;
    }
  }

  String checkLocationAddress(String value,
      {@required String label, int min = 2, int max = 1000}) {
    if (value.trim().length < min || value.isEmpty) {
      return "$label $kTooShort";
    } else if (value.trim().length > max) {
      return "$label $kTooLong";
    } else if (value.contains("#")) {
      return "$label $kLocationErrorText";
    } else
      return null;
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
      "personalBio": personalBioController.text,
      "location": locationController.text,
      "birthDate": birthDateController.text,
      "gender": genderController.text,
      "professionalCategory": professionalCategory,
      "professionalTitle": professionalTitleController.text,
      "professionalDescription": professionalDescriptionController.text,
      "keyWords": "$keyWord1Controller;$keyWord2Controller;"
          "$keyWord3Controller;$keyWord4Controller;",
      "diploma": diplomaController.text,
      "licence": licenceController.text,
      "certification": certificationController.text,
      "language": languageController.text,
      "experience": experienceController.text,
      "internship": internshipController.text,
      "competence": competenceController.text,
      "achievement": achievementController.text,
      "recommendation": recommendationController.text,
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
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: StatefulBuilder(
            builder: (context, setState) => SimpleDialog(
              title: Text(kSelectLocation),
              children: <Widget>[
                buildLocationDropdownMenu(setState),
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

  showCategoryList(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return Scaffold(
          key: _categoryScaffoldKey,
          backgroundColor: Colors.transparent,
          body: StatefulBuilder(
            builder: (context, setState) => SimpleDialog(
              title: Text(kSelectLocation),
              children: <Widget>[
                buildProfessionalCategoryDropdownMenu(context, setState),
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

  ListTile buildListTile(
    StateSetter setState, {
    Function(String val) onChanged,
    Function(TextEditingController controller) onAddFieldIconPressed,
    bool hasTrailing = true,
    @required String value,
    @required List<String> items,
    TextEditingController parentController,
    String addFieldHint,
  }) {
    final TextEditingController controller = TextEditingController();
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
          onChanged: (value) {
            onChanged(value);
          },
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
      trailing: hasTrailing
          ? Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => parentController?.text?.trim()?.isNotEmpty ??
                        true
                    ? Scaffold.of(context).showBottomSheet(
                        (BuildContext context) => Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: CustomTextFormField(
                            hint: addFieldHint,
                            controller: controller,
                            trailing: IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () =>
                                  onAddFieldIconPressed(controller),
                            ),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                      )
                    : _categoryScaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text("prentEmpty"))),
              ),
            )
          : Container(
              width: 0,
            ),
    );
  }

  buildProfessionalCategoryDropdownMenu(
      BuildContext context, StateSetter setState) {
    return Column(
      children: [
        buildListTile(
          setState,
          value: professionalCategory,
          onChanged: (String val) {
            setState(() {
              professionalTitle = null;
              professionalTitleController.clear();
              professionalCategory = val;
              professionalCategoryController.text = val;
              getProfessionalTitlesList(setState);
            });
          },
          items: professionalCategoriesList,

          // Belongs to bottomSheet context
          addFieldHint: kAddProfessionalCategory,
          parentController: null,
          onAddFieldIconPressed: (controller) {
            if (checkLength(controller.text, label: kCheckProfessionalTitle) ==
                null) {
              handleAddProfessionalCategoriesList(
                      setState: setState, professionalCategory: controller.text)
                  .then((_) {
                setState(() {
                  professionalCategory = controller.text;
                  professionalCategoryController.text = professionalCategory;
                });
                Navigator.pop(context);
                controller.clear();
              });
            }
          },
        ),
        buildListTile(
          setState,
          value: professionalTitle,
          onChanged: (String value) {
            setState(() {
              professionalTitle = value;
              professionalTitleController.text = value;
            });
          },
          items: professionalTitlesList,
          addFieldHint: kAddProfessionalTitle,
          parentController: professionalCategoryController,
          onAddFieldIconPressed: (controller) {
            if (checkLength(controller.text,
                    label: kCheckProfessionalCategory) ==
                null) {
              handleAddProfessionalTitlesList(
                      setState: setState, professionalTitle: controller.text)
                  .then((_) {
                setState(() {
                  professionalTitle = controller.text;
                });
                Navigator.pop(context);
                controller.clear();
              });
            }
          },
        ),
      ],
    );
  }

  buildLocationDropdownMenu(StateSetter setState) {
    return Column(
      children: [
        buildListTile(
          setState,
          value: country,
          onChanged: (String val) {
            setState(() {
              administrativeArea = null;
              subAdministrativeArea = null;
              country = val;
              locationController.text = "${subAdministrativeArea ?? "#"}, "
                  "${administrativeArea ?? "#"}, ${country ?? "#"}";
              getAdministrativeAreasList(setState);
            });
          },
          items: countriesList,
          hasTrailing: false,
          // Add formField BottomSheet
        ),
        buildListTile(
          setState,
          value: administrativeArea,
          onChanged: (String val) {
            setState(() {
              subAdministrativeArea = null;
              administrativeArea = val;
              locationController.text = "${subAdministrativeArea ?? "#"}, "
                  "${administrativeArea ?? "#"}, ${country ?? "#"}";
              getSubAdministrativeAreasList(setState);
            });
          },
          items: administrativeAreasList,
          hasTrailing: false,
        ),
        buildListTile(
          setState,
          value: subAdministrativeArea,
          onChanged: (String val) {
            setState(() {
              subAdministrativeArea = val;
              locationController.text = "${subAdministrativeArea ?? "#"}, "
                  "${administrativeArea ?? "#"}, ${country ?? "#"}";
            });
          },
          items: subAdministrativeAreasList,
          hasTrailing: false,
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
    // TODO fix permission issue
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String formattedAddress =
        " ${placemark.subAdministrativeArea}, ${placemark.administrativeArea},"
        " ${placemark.country}";
    locationController.text = formattedAddress;
    addLocation(
        country: country,
        administrativeArea: administrativeArea,
        subAdministrativeArea: subAdministrativeArea);
  }

  updateInstruction(String instruction) {
    setState(() {
      this.instruction = instruction;
    });
  }

  Future<void> getCategoriesList() async {
    QuerySnapshot snapshot = await categoriesRef.getDocuments();
    setState(() {
      professionalCategoriesList =
          snapshot.documents.map((doc) => doc.documentID).toList();
      professionalTitlesList = [""];
    });
  }

  Future<void> getProfessionalTitlesList(StateSetter setState) async {
    QuerySnapshot snapshot = await categoriesRef
        .document(professionalCategory)
        .collection("professionalTitles")
        .getDocuments();
    setState(() {
      professionalTitlesList =
          snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  getCountriesList() async {
    QuerySnapshot snapshot = await locationsRef.getDocuments();
    setState(() {
      countriesList = snapshot.documents.map((doc) => doc.documentID).toList();
      administrativeAreasList = [""];
      subAdministrativeAreasList = [""];
    });
  }

  Future<void> getAdministrativeAreasList(StateSetter setState) async {
    if (country.isNotEmpty) {
      QuerySnapshot snapshot = await locationsRef
          .document(country)
          .collection("administrativeAreas")
          .getDocuments();
      setState(() {
        administrativeAreasList =
            snapshot.documents.map((doc) => doc.documentID).toList();
        subAdministrativeAreasList = [""];
      });
    }
  }

  Future<void> getSubAdministrativeAreasList(StateSetter setState) async {
    if (country.isNotEmpty && administrativeArea.isNotEmpty) {
      QuerySnapshot snapshot = await locationsRef
          .document(country)
          .collection("administrativeAreas")
          .document(administrativeArea)
          .collection("subAdministrativeAreas")
          .getDocuments();
      setState(() {
        subAdministrativeAreasList =
            snapshot.documents.map((doc) => doc.documentID).toList();
      });
    }
  }

  Future<void> handleAddProfessionalCategoriesList(
      {StateSetter setState, String professionalCategory}) async {
    if (professionalCategory.isNotEmpty) {
      await categoriesRef.document(professionalCategory).setData({});
      getCategoriesList();
    }
  }

  Future<void> handleAddProfessionalTitlesList(
      {StateSetter setState, String professionalTitle}) async {
    if (professionalTitle.isNotEmpty) {
      await categoriesRef
          .document(professionalCategory)
          .collection("professionalTitles")
          .document(professionalTitle)
          .setData({});
      getProfessionalTitlesList(setState);
    }
  }

  Future<void> addLocation(
      {String country,
      String administrativeArea,
      String subAdministrativeArea}) async {
    return await locationsRef
        .document(country)
        .collection("administrativeAreas")
        .document(administrativeArea)
        .collection("subAdministrativeAreas")
        .document(subAdministrativeArea)
        .setData({});
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
