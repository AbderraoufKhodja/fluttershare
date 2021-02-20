import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khadamat/models/firestore_field.dart';

class AppUser {
  final FirestoreField<String> uid;
  FirestoreField<String> username;
  FirestoreField<String> displayName;
  FirestoreField<String> photoURL;
  FirestoreField<String> email;
  FirestoreField<bool> isFreelancer;
  FirestoreField<bool> teamChoice;
  FirestoreField<String> professionalPhotoUrl;
  FirestoreField<String> personalBio;
  FirestoreField<String> gender;
  FirestoreField<Map> location;
  FirestoreField<Timestamp> birthDate;
  FirestoreField<String> professionalCategory;
  FirestoreField<String> professionalTitle;
  FirestoreField<String> professionalDescription;
  FirestoreField<List> preferences;
  FirestoreField<Map> reviews;
  FirestoreField<Map> jobs;
  FirestoreField<double> globalRate;
  FirestoreField<double> jobsCount;
  FirestoreField<double> completionRate;
  FirestoreField<double> popularityRate;
  FirestoreField<double> qualityRate;
  FirestoreField<double> attitudeRate;
  FirestoreField<double> timeManagementRate;
  FirestoreField<String> diploma;
  FirestoreField<String> licence;
  FirestoreField<String> certification;
  FirestoreField<String> language;
  FirestoreField<String> experience;
  FirestoreField<String> internship;
  FirestoreField<String> competence;
  FirestoreField<String> achievement;
  FirestoreField<String> recommendation;
  final FirestoreField<Timestamp> createdAt;

  AppUser({
    this.uid,
    this.username,
    this.displayName,
    this.photoURL,
    this.email,
    this.isFreelancer,
    this.teamChoice,
    this.professionalPhotoUrl,
    this.personalBio,
    this.gender,
    this.location,
    this.birthDate,
    this.professionalCategory,
    this.professionalTitle,
    this.professionalDescription,
    this.preferences,
    this.reviews,
    this.jobs,
    this.globalRate,
    this.jobsCount,
    this.completionRate,
    this.popularityRate,
    this.qualityRate,
    this.attitudeRate,
    this.diploma,
    this.licence,
    this.certification,
    this.language,
    this.experience,
    this.internship,
    this.competence,
    this.achievement,
    this.recommendation,
    this.createdAt,
  });

  factory AppUser.clientFromDocument(DocumentSnapshot doc) {
    return AppUser(
      uid: FirestoreField<String>.fromDocument(doc: doc, name: "uid"),
      displayName:
          FirestoreField<String>.fromDocument(doc: doc, name: "displayName"),
      email: FirestoreField<String>.fromDocument(doc: doc, name: "email"),
      username: FirestoreField<String>.fromDocument(name: "username", doc: doc),
      photoURL: FirestoreField<String>.fromDocument(doc: doc, name: "photoURL"),
      isFreelancer:
          FirestoreField<bool>.fromDocument(doc: doc, name: "isFreelancer"),
      preferences: FirestoreField<List<String>>.fromDocument(
          doc: doc, name: "preferences"),
      reviews: FirestoreField<Map>.fromDocument(doc: doc, name: "reviews"),
      jobs: FirestoreField<Map>.fromDocument(doc: doc, name: "jobs"),
      createdAt:
          FirestoreField<Timestamp>.fromDocument(doc: doc, name: "createdAt"),
    );
  }
  factory AppUser.freelancerFromDocument(DocumentSnapshot doc) {
    return AppUser(
      uid: FirestoreField<String>.fromDocument(doc: doc, name: "uid"),
      username: FirestoreField<String>.fromDocument(doc: doc, name: "username"),
      displayName:
          FirestoreField<String>.fromDocument(doc: doc, name: "displayName"),
      photoURL: FirestoreField<String>.fromDocument(doc: doc, name: "photoURL"),
      email: FirestoreField<String>.fromDocument(doc: doc, name: "email"),
      isFreelancer:
          FirestoreField<bool>.fromDocument(doc: doc, name: "isFreelancer"),
      teamChoice:
          FirestoreField<bool>.fromDocument(doc: doc, name: "teamChoice"),
      professionalPhotoUrl: FirestoreField<String>.fromDocument(
          doc: doc, name: "professionalPhotoUrl"),
      personalBio:
          FirestoreField<String>.fromDocument(doc: doc, name: "personalBio"),
      gender: FirestoreField<String>.fromDocument(doc: doc, name: "gender"),
      location: FirestoreField<Map>.fromDocument(doc: doc, name: "location"),
      birthDate:
          FirestoreField<Timestamp>.fromDocument(doc: doc, name: "birthDate"),
      professionalCategory: FirestoreField<String>.fromDocument(
          doc: doc, name: "professionalCategory"),
      professionalTitle: FirestoreField<String>.fromDocument(
          doc: doc, name: "professionalTitle"),
      professionalDescription: FirestoreField<String>.fromDocument(
          doc: doc, name: "professionalDescription"),
      jobsCount:
          FirestoreField<double>.fromDocument(doc: doc, name: "jobsCount"),
      globalRate:
          FirestoreField<double>.fromDocument(doc: doc, name: "globalRate"),
      completionRate:
          FirestoreField<double>.fromDocument(doc: doc, name: "completionRate"),
      popularityRate:
          FirestoreField<double>.fromDocument(doc: doc, name: "popularityRate"),
      qualityRate:
          FirestoreField<double>.fromDocument(doc: doc, name: "qualityRate"),
      attitudeRate:
          FirestoreField<double>.fromDocument(doc: doc, name: "attitudeRate"),
      preferences: FirestoreField<List<String>>.fromDocument(
          doc: doc, name: "preferences"),
      reviews: FirestoreField<Map>.fromDocument(doc: doc, name: "reviews"),
      jobs: FirestoreField<Map>.fromDocument(doc: doc, name: "jobs"),
      diploma: FirestoreField<String>.fromDocument(doc: doc, name: "diploma"),
      licence: FirestoreField<String>.fromDocument(doc: doc, name: "licence"),
      certification:
          FirestoreField<String>.fromDocument(doc: doc, name: "certification"),
      language: FirestoreField<String>.fromDocument(doc: doc, name: "language"),
      experience:
          FirestoreField<String>.fromDocument(doc: doc, name: "experience"),
      internship:
          FirestoreField<String>.fromDocument(doc: doc, name: "internship"),
      competence:
          FirestoreField<String>.fromDocument(doc: doc, name: "competence"),
      achievement:
          FirestoreField<String>.fromDocument(doc: doc, name: "achievement"),
      recommendation:
          FirestoreField<String>.fromDocument(doc: doc, name: "recommendation"),
      createdAt:
          FirestoreField<Timestamp>.fromDocument(doc: doc, name: "createdAt"),
    );
  }
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    if (FirestoreField<bool>.fromDocument(doc: doc, name: "isFreelancer")
            .value ==
        true)
      return AppUser.freelancerFromDocument(doc);
    else
      return AppUser.clientFromDocument(doc);
  }
}
