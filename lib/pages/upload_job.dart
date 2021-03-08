import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/models/firestore_field.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/google_map_page.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_text_form_field.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class UploadJob extends StatefulWidget {
  UploadJob({AppUser currentUser});

  @override
  _UploadJobState createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob>
    with AutomaticKeepAliveClientMixin<UploadJob> {
  TextEditingController jobTitleController = TextEditingController();
  GeoFirePoint jobGeoFirePoint;
  TextEditingController jobLocationController = TextEditingController();
  TextEditingController dateRangeController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController professionalCategoryController =
      TextEditingController();
  TextEditingController professionalTitleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
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
  final _formKey = GlobalKey<FormState>();
  final _categoryScaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  final geo = GeoFlutterFire();

  String jobId = Uuid().v4();
  File file;
  bool isUploading = false;

  int valIndex = 0;
  String instruction = kTellUsAboutYou;
  DateTimeRange dateRange;

  bool get wantKeepAlive => true;

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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            isUploading ? linearProgress() : Text(""),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(instruction),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: file == null
                      ? GestureDetector(
                          onTap: () => selectImage(context),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 0,
                                  ),
                                ]),
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.add_a_photo,
                              size: 100.0,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => selectImage(context),
                          child: Container(
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(image: FileImage(file)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 0,
                                  ),
                                ]),
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.all(10.0),
                          ),
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
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    CustomTextFormField(
                        validator: (text) =>
                            checkLength(text, label: kLocation),
                        controller: jobTitleController,
                        hint: kJobTitleHint,
                        onTap: () {
                          updateInstruction(kJobTitleInstruction);
                        }),
                    CustomTextFormField(
                        validator: (text) =>
                            checkLocationAddress(text, label: kLocation),
                        controller: null,
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
                        controller: dateRangeController,
                        hint: kDateRangeHint,
                        trailing: buildBirthDateGestureDetector(),
                        readOnly: true,
                        onTap: () {
                          updateInstruction(kDateRangeInstruction);
                          showCalender();
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
                        controller: jobDescriptionController,
                        maxLines: null,
                        hint: kProfessionalDescription,
                        onTap: () => updateInstruction(
                            kProfessionalDescriptionInstruction)),
                    CustomTextFormField(
                        validator: (text) =>
                            checkLength(text, label: kProfessionalDescription),
                        enableInteractiveSelection: false,
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        hint: kPriceHint,
                        onTap: () => updateInstruction(kPriceInstruction)),
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

  handleSubmit() async {
    //TODO: Deactivate button to avoid multiple submit
    final form = _formKey.currentState;
    form.save();
    if ((form.validate())) {
      setState(() {
        isUploading = true;
      });
      if (file != null) await compressImage();
      String jobPhotoUrl =
          file == null ? kBlankProfileUrl : await uploadImage(file);
      Job(
        jobId: FirestoreField<String>(name: "jobId", value: jobId),
        jobOwnerId: FirestoreField<String>(
            name: "jobOwnerId", value: currentUser.uid.value),
        jobOwnerName: FirestoreField<String>(
            name: "jobOwnerName", value: currentUser.username.value),
        jobOwnerEmail: FirestoreField<String>(
            name: "jobOwnerEmail", value: currentUser.email.value),
        isOwnerFreelancer: FirestoreField<bool>(
            name: "isOwnerFreelancer", value: currentUser.isFreelancer.value),
        jobTitle: FirestoreField<String>(
            name: "jobTitle", value: jobTitleController.text),
        professionalCategory: FirestoreField<String>(
            name: "professionalCategory",
            value: professionalCategoryController.text),
        professionalTitle: FirestoreField<String>(
            name: "professionalTitle", value: professionalTitleController.text),
        jobDescription: FirestoreField<String>(
            name: "jobDescription", value: jobDescriptionController.text),
        location: FirestoreField<Map>(name: "location", value: {
          'formattedAddress': jobLocationController.text,
          'geoFirePoint': jobGeoFirePoint.data,
        }),
        dateRange: FirestoreField<String>(
            name: "dateRange", value: dateRangeController.text),
        jobPhotoUrl:
            FirestoreField<String>(name: "jobPhotoUrl", value: jobPhotoUrl),
        price:
            FirestoreField<String>(name: "price", value: priceController.text),
        applications: FirestoreField<Map>(name: "applications", value: null),
        hasFreelancerUpdateRequest: FirestoreField<bool>(
            name: "hasFreelancerUpdateRequest", value: false),
        hasOwnerUpdateRequest:
            FirestoreField<bool>(name: "hasOwnerUpdateRequest", value: false),
        jobState: FirestoreField<String>(name: "jobState", value: "open"),
        isOwnerCompleted:
            FirestoreField<bool>(name: "isOwnerCompleted", value: false),
        isFreelancerCompleted:
            FirestoreField<bool>(name: "isFreelancerCompleted", value: false),
      ).createJob();
      clearControllers();
      setState(() {
        clearImage();
        isUploading = false;
        jobId = Uuid().v4();
      });
      Navigator.pop(context, true);
    }
  }

// TODO handle pick image for web here and elsewhere
  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      if (imageFile != null) this.file = File(imageFile.path);
    });
  }

  // TODO handle pick image for web here and elsewhere
  handleChooseFromGallery() async {
    Navigator.pop(context);
    PickedFile imageFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      if (imageFile != null) this.file = File(imageFile.path);
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
    file = null;
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/job_$jobId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadCardTask =
        storageRef.child("job_$jobId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadCardTask.whenComplete(() {});
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  clearControllers() {
    professionalTitleController.clear();
    jobGeoFirePoint = null;
    jobDescriptionController.clear();
    dateRangeController.clear();
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
    final datePick = await showDateRangePicker(
        context: context,
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2100));
    if (datePick != null && datePick != dateRange) {
      setState(() {
        dateRange = datePick;
        dateRangeController.text =
            "${dateRange.start.day}/${dateRange.start.month}/"
            "${dateRange.start.year} to ${dateRange.end.day}/"
            "${dateRange.end.month}/${dateRange.end.year}"; // 08/14/2019
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
                  professionalTitleController.text = professionalTitle;
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
              // TODO: revisit get location logic
              // locationGeoPoint != "${subAdministrativeArea ?? "#"}, "
              //     "${administrativeArea ?? "#"}, ${country ?? "#"}";
              getAdministrativeAreasList(setState);
            });
          },
          items: countriesList,
          hasTrailing: false,
          // Add formField BottomSheet
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
      onTap: () async {
        Map result = await showGoogleMaps(context);
        if (result != null) {
          jobLocationController.text = result['formattedAddress'];
          jobGeoFirePoint = result['geoFirePoint'];
        }
      },
    );
  }

  // getJobLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   Position position;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permantly denied, we cannot request permissions.');
  //   }

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission != LocationPermission.whileInUse &&
  //         permission != LocationPermission.always) {
  //       return Future.error(
  //           'Location permissions are denied (actual value: $permission).');
  //     }
  //   }
  //   position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark placemark = placemarks[0];
  //   String formattedAddress =
  //       " ${placemark.subAdministrativeArea}, ${placemark.administrativeArea},"
  //       " ${placemark.country}";
  //   jobLocationController.text = formattedAddress;
  //   jobGeoFirePoint =
  //       geo.point(latitude: position.latitude, longitude: position.longitude);
  //   // addLocation(
  //   //     latitude: position.latitude,
  //   //     longitude: position.longitude,
  //   //     country: country,
  //   //     administrativeArea: administrativeArea,
  //   //     subAdministrativeArea: subAdministrativeArea);
  // }

  updateInstruction(String instruction) {
    setState(() {
      this.instruction = instruction;
    });
  }

  Future<void> getCategoriesList() async {
    QuerySnapshot snapshot = await categoriesRef.get();
    setState(() {
      professionalCategoriesList = snapshot.docs.map((doc) => doc.id).toList();
      professionalTitlesList = [""];
    });
  }

  Future<void> getProfessionalTitlesList(StateSetter setState) async {
    QuerySnapshot snapshot = await categoriesRef
        .doc(professionalCategory)
        .collection("professionalTitles")
        .get();
    setState(() {
      professionalTitlesList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  getCountriesList() async {
    QuerySnapshot snapshot = await locationsRef.get();
    setState(() {
      countriesList = snapshot.docs.map((doc) => doc.id).toList();
      administrativeAreasList = [""];
      subAdministrativeAreasList = [""];
    });
  }

  Future<void> getAdministrativeAreasList(StateSetter setState) async {
    if (country.isNotEmpty) {
      QuerySnapshot snapshot = await locationsRef
          .doc(country)
          .collection("administrativeAreas")
          .get();
      setState(() {
        administrativeAreasList = snapshot.docs.map((doc) => doc.id).toList();
        subAdministrativeAreasList = [""];
      });
    }
  }

  Future<void> getSubAdministrativeAreasList(StateSetter setState) async {
    if (country.isNotEmpty && administrativeArea.isNotEmpty) {
      QuerySnapshot snapshot = await locationsRef
          .doc(country)
          .collection("administrativeAreas")
          .doc(administrativeArea)
          .collection("subAdministrativeAreas")
          .get();
      setState(() {
        subAdministrativeAreasList =
            snapshot.docs.map((doc) => doc.id).toList();
      });
    }
  }

  Future<void> handleAddProfessionalCategoriesList(
      {StateSetter setState, String professionalCategory}) async {
    if (professionalCategory.isNotEmpty) {
      await categoriesRef.doc(professionalCategory).set({});
      await getCategoriesList();
    }
  }

  Future<void> handleAddProfessionalTitlesList(
      {StateSetter setState, String professionalTitle}) async {
    if (professionalTitle.isNotEmpty) {
      await categoriesRef
          .doc(professionalCategory)
          .collection("professionalTitles")
          .doc(professionalTitle)
          .set({});
      await getProfessionalTitlesList(setState);
    }
  }

  // Future<void> addLocation(
  //     {String country,
  //     String administrativeArea,
  //     String subAdministrativeArea}) async {
  //   return await locationsRef
  //       .doc(country)
  //       .collection("administrativeAreas")
  //       .doc(administrativeArea)
  //       .collection("subAdministrativeAreas")
  //       .doc(subAdministrativeArea)
  //       .set({});
  // }
}

Future<bool> showUploadJobScreen(BuildContext context,
    {AppUser currentUser}) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UploadJob(
        currentUser: currentUser,
      ),
    ),
  );
}
