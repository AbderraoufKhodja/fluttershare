import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khadamat/pages/ultils.dart';

class AppUser {
  final String uid;
  String username;
  String displayName;
  String photoURL;
  String email;
  bool isFreelancer;
  bool teamChoice;
  String professionalPhotoUrl;
  String personalBio;
  String gender;
  Map location;
  Timestamp birthDate;
  String professionalCategory;
  String professionalTitle;
  String professionalDescription;
  List preferences;
  Map reviews;
  Map jobs;
  double globalRate;
  double jobsCount;
  double completionRate;
  double popularityRate;
  double qualityRating;
  double attitudeRating;
  double timeManagementRating;
  String diploma;
  String licence;
  String certification;
  String language;
  String experience;
  String internship;
  String competence;
  String achievement;
  String recommendation;
  final Timestamp createdAt;

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
    this.qualityRating,
    this.attitudeRating,
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
      uid: fieldGetter(document: doc, field: 'uid'),
      displayName: fieldGetter(document: doc, field: 'displayName'),
      email: fieldGetter(document: doc, field: 'email'),
      username: fieldGetter(document: doc, field: 'username'),
      photoURL: fieldGetter(document: doc, field: 'photoURL'),
      isFreelancer: fieldGetter(document: doc, field: 'isFreelancer'),
      preferences: fieldGetter(document: doc, field: 'preferences'),
      reviews: fieldGetter(document: doc, field: 'reviews'),
      jobs: fieldGetter(document: doc, field: 'jobs'),
      createdAt: fieldGetter(document: doc, field: 'createdAt'),
    );
  }
  factory AppUser.freelancerFromDocument(DocumentSnapshot doc) {
    return AppUser(
      uid: fieldGetter(document: doc, field: 'uid', type: String),
      username: fieldGetter(document: doc, field: 'username', type: String),
      displayName:
          fieldGetter(document: doc, field: 'displayName', type: String),
      photoURL: fieldGetter(document: doc, field: 'photoURL', type: String),
      email: fieldGetter(document: doc, field: 'email', type: String),
      isFreelancer:
          fieldGetter(document: doc, field: 'isFreelancer', type: bool),
      teamChoice: fieldGetter(document: doc, field: 'teamChoice', type: bool),
      professionalPhotoUrl: fieldGetter(
          document: doc, field: 'professionalPhotoUrl', type: String),
      personalBio:
          fieldGetter(document: doc, field: 'personalBio', type: String),
      gender: fieldGetter(document: doc, field: 'gender', type: String),
      location: fieldGetter(document: doc, field: 'location', type: Map),
      birthDate:
          fieldGetter(document: doc, field: 'birthDate', type: Timestamp),
      professionalCategory: fieldGetter(
          document: doc, field: 'professionalCategory', type: String),
      professionalTitle:
          fieldGetter(document: doc, field: 'professionalTitle', type: String),
      professionalDescription: fieldGetter(
          document: doc, field: 'professionalDescription', type: String),
      jobsCount: fieldGetter(document: doc, field: 'jobsCount', type: double),
      globalRate: fieldGetter(document: doc, field: 'globalRate', type: double),
      completionRate:
          fieldGetter(document: doc, field: 'completionRate', type: double),
      popularityRate:
          fieldGetter(document: doc, field: 'popularityRate', type: double),
      qualityRating:
          fieldGetter(document: doc, field: 'qualityRate', type: double),
      attitudeRating:
          fieldGetter(document: doc, field: 'attitudeRate', type: double),
      preferences: fieldGetter(document: doc, field: 'preferences', type: List),
      reviews: fieldGetter(document: doc, field: 'reviews', type: Map),
      jobs: fieldGetter(document: doc, field: 'jobs', type: Map),
      diploma: fieldGetter(document: doc, field: 'diploma', type: String),
      licence: fieldGetter(document: doc, field: 'licence', type: String),
      certification:
          fieldGetter(document: doc, field: 'certification', type: String),
      language: fieldGetter(document: doc, field: 'language', type: String),
      experience: fieldGetter(document: doc, field: 'experience', type: String),
      internship: fieldGetter(document: doc, field: 'internship', type: String),
      competence: fieldGetter(document: doc, field: 'competence', type: String),
      achievement:
          fieldGetter(document: doc, field: 'achievement', type: String),
      recommendation:
          fieldGetter(document: doc, field: 'recommendation', type: String),
      createdAt:
          fieldGetter(document: doc, field: 'createdAt', type: Timestamp),
    );
  }
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    if (doc['isFreelancer'] == true)
      return AppUser.freelancerFromDocument(doc);
    else
      return AppUser.clientFromDocument(doc);
  }
}
