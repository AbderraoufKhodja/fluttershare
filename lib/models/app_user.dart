import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khadamat/constants.dart';

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
  Map<String, dynamic> location;
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
    // TODO fix int double type error for number fields
    return AppUser(
      uid: fieldGetter(document: doc, field: 'uid'),
      username: fieldGetter(document: doc, field: 'username'),
      displayName: fieldGetter(document: doc, field: 'displayName'),
      photoURL: fieldGetter(document: doc, field: 'photoURL'),
      email: fieldGetter(document: doc, field: 'email'),
      isFreelancer: fieldGetter(document: doc, field: 'isFreelancer'),
      teamChoice: fieldGetter(document: doc, field: 'teamChoice'),
      professionalPhotoUrl:
          fieldGetter(document: doc, field: 'professionalPhotoUrl'),
      personalBio: fieldGetter(document: doc, field: 'personalBio'),
      gender: fieldGetter(document: doc, field: 'gender'),
      location: fieldGetter(document: doc, field: 'location'),
      birthDate: fieldGetter(document: doc, field: 'birthDate'),
      professionalCategory:
          fieldGetter(document: doc, field: 'professionalCategory'),
      professionalTitle: fieldGetter(document: doc, field: 'professionalTitle'),
      professionalDescription:
          fieldGetter(document: doc, field: 'professionalDescription'),
      globalRate: fieldGetter(document: doc, field: 'globalRate'),
      jobsCount: fieldGetter(document: doc, field: 'jobsCount'),
      completionRate: fieldGetter(document: doc, field: 'completionRate'),
      popularityRate: fieldGetter(document: doc, field: 'popularityRate'),
      qualityRating: fieldGetter(document: doc, field: 'qualityRate'),
      attitudeRating: fieldGetter(document: doc, field: 'attitudeRate'),
      preferences: fieldGetter(document: doc, field: 'preferences'),
      reviews: fieldGetter(document: doc, field: 'reviews'),
      jobs: fieldGetter(document: doc, field: 'jobs'),
      diploma: fieldGetter(document: doc, field: 'diploma'),
      licence: fieldGetter(document: doc, field: 'licence'),
      certification: fieldGetter(document: doc, field: 'certification'),
      language: fieldGetter(document: doc, field: 'language'),
      experience: fieldGetter(document: doc, field: 'experience'),
      internship: fieldGetter(document: doc, field: 'internship'),
      competence: fieldGetter(document: doc, field: 'competence'),
      achievement: fieldGetter(document: doc, field: 'achievement'),
      recommendation: fieldGetter(document: doc, field: 'recommendation'),
      createdAt: fieldGetter(document: doc, field: 'createdAt'),
    );
  }
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    if (doc['isFreelancer'] == true)
      return AppUser.freelancerFromDocument(doc);
    else
      return AppUser.clientFromDocument(doc);
  }
}
