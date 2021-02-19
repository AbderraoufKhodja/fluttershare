import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khadamat/models/firestore_field.dart';
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
  double qualityRate;
  double attitudeRate;
  double timeManagementRate;
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
      uid: fieldGetter(document: doc, field: ffAppUserUid),
      displayName: fieldGetter(document: doc, field: ffAppUserDisplayName),
      email: fieldGetter(document: doc, field: ffAppUserEmail),
      username: fieldGetter(document: doc, field: ffAppUserUsername),
      photoURL: fieldGetter(document: doc, field: ffAppUserPhotoURL),
      isFreelancer: fieldGetter(document: doc, field: ffAppUserIsFreelancer),
      preferences: fieldGetter(document: doc, field: ffAppUserPreferences),
      reviews: fieldGetter(document: doc, field: ffAppUserReviews),
      jobs: fieldGetter(document: doc, field: ffAppUserJobs),
      createdAt: fieldGetter(document: doc, field: ffAppUserCreatedAt),
    );
  }
  factory AppUser.freelancerFromDocument(DocumentSnapshot doc) {
    return AppUser(
      uid: fieldGetter(document: doc, field: ffAppUserUid),
      username: fieldGetter(document: doc, field: ffAppUserUsername),
      displayName:
          fieldGetter(document: doc, field: ffAppUserDisplayName),
      photoURL: fieldGetter(document: doc, field: ffAppUserPhotoURL),
      email: fieldGetter(document: doc, field: ffAppUserEmail),
      isFreelancer:
          fieldGetter(document: doc, field: ffAppUserIsFreelancer),
      teamChoice: fieldGetter(document: doc, field: ffAppUserTeamChoice),
      professionalPhotoUrl: fieldGetter(
          document: doc, field: ffAppUserProfessionalPhotoUrl),
      personalBio:
          fieldGetter(document: doc, field: ffAppUserPersonalBio),
      gender: fieldGetter(document: doc, field: ffAppUserGender),
      location: fieldGetter(document: doc, field: ffAppUserLocation),
      birthDate:
          fieldGetter(document: doc, field: ffAppUserBirthDate),
      professionalCategory: fieldGetter(
          document: doc, field: ffAppUserProfessionalCategory),
      professionalTitle:
          fieldGetter(document: doc, field: ffAppUserProfessionalTitle),
      professionalDescription: fieldGetter(
          document: doc, field: ffAppUserProfessionalDescription),
      jobsCount: fieldGetter(document: doc, field: ffAppUserJobsCount),
      globalRate: fieldGetter(document: doc, field: ffAppUserGlobalRate),
      completionRate:
          fieldGetter(document: doc, field: ffAppUserCompletionRate),
      popularityRate:
          fieldGetter(document: doc, field: ffAppUserPopularityRate),
      qualityRate:
          fieldGetter(document: doc, field: ffAppUserQualityRate),
      attitudeRate:
          fieldGetter(document: doc, field: ffAppUserAttitudeRate),
      preferences: fieldGetter(document: doc, field: ffAppUserPreferences),
      reviews: fieldGetter(document: doc, field: ffAppUserReviews),
      jobs: fieldGetter(document: doc, field: ffAppUserJobs),
      diploma: fieldGetter(document: doc, field: ffAppUserDiploma),
      licence: fieldGetter(document: doc, field: ffAppUserLicence),
      certification:
          fieldGetter(document: doc, field: ffAppUserCertification),
      language: fieldGetter(document: doc, field: ffAppUserLanguage),
      experience: fieldGetter(document: doc, field: ffAppUserExperience),
      internship: fieldGetter(document: doc, field: ffAppUserInternship),
      competence: fieldGetter(document: doc, field: ffAppUserCompetence),
      achievement:
          fieldGetter(document: doc, field: ffAppUserAchievement),
      recommendation:
          fieldGetter(document: doc, field: ffAppUserRecommendation),
      createdAt:
          fieldGetter(document: doc, field: ffAppUserCreatedAt),
    );
  }
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    if (fieldGetter(document: doc, field: ffAppUserIsFreelancer) == true)
      return AppUser.freelancerFromDocument(doc);
    else
      return AppUser.clientFromDocument(doc);
  }
}

final FirestoreField ffAppUserUid = FirestoreField(name: "uid");
final FirestoreField ffAppUserUsername =
    FirestoreField(name: "username");
final FirestoreField ffAppUserDisplayName =
    FirestoreField(name: "displayName");
final FirestoreField ffAppUserPhotoURL =
    FirestoreField(name: "photoURL");
final FirestoreField ffAppUserEmail = FirestoreField(name: "email");
final FirestoreField ffAppUserIsFreelancer =
    FirestoreField(name: "isFreelancer");
final FirestoreField ffAppUserTeamChoice =
    FirestoreField(name: "teamChoice");
final FirestoreField ffAppUserProfessionalPhotoUrl =
    FirestoreField(name: "professionalPhotoUrl");
final FirestoreField ffAppUserPersonalBio =
    FirestoreField(name: "personalBio");
final FirestoreField ffAppUserGender = FirestoreField(name: "gender");
final FirestoreField ffAppUserLocation =
    FirestoreField(name: "location");
final FirestoreField ffAppUserBirthDate =
    FirestoreField(name: "birthDate");
final FirestoreField ffAppUserProfessionalCategory =
    FirestoreField(name: "professionalCategory");
final FirestoreField ffAppUserProfessionalTitle =
    FirestoreField(name: "professionalTitle");
final FirestoreField ffAppUserProfessionalDescription =
    FirestoreField(name: "professionalDescription");
final FirestoreField ffAppUserPreferences =
    FirestoreField(name: "preferences");
final FirestoreField ffAppUserReviews = FirestoreField(name: "reviews");
final FirestoreField ffAppUserJobs = FirestoreField(name: "jobs");
final FirestoreField ffAppUserGlobalRate =
    FirestoreField(name: "globalRate");
final FirestoreField ffAppUserJobsCount =
    FirestoreField(name: "jobsCount");
final FirestoreField ffAppUserCompletionRate =
    FirestoreField(name: "completionRate");
final FirestoreField ffAppUserPopularityRate =
    FirestoreField(name: "popularityRate");
final FirestoreField ffAppUserQualityRate =
    FirestoreField(name: "qualityRate");
final FirestoreField ffAppUserAttitudeRate =
    FirestoreField(name: "attitudeRate");
final FirestoreField ffAppUserTimeManagementRate =
    FirestoreField(name: "timeManagementRate");
final FirestoreField ffAppUserDiploma = FirestoreField(name: "diploma");
final FirestoreField ffAppUserLicence = FirestoreField(name: "licence");
final FirestoreField ffAppUserCertification =
    FirestoreField(name: "certification");
final FirestoreField ffAppUserLanguage =
    FirestoreField(name: "language");
final FirestoreField ffAppUserExperience =
    FirestoreField(name: "experience");
final FirestoreField ffAppUserInternship =
    FirestoreField(name: "internship");
final FirestoreField ffAppUserCompetence =
    FirestoreField(name: "competence");
final FirestoreField ffAppUserAchievement =
    FirestoreField(name: "achievement");
final FirestoreField ffAppUserRecommendation =
    FirestoreField(name: "recommendation");
final FirestoreField ffAppUserCreatedAt =
    FirestoreField(name: "createdAt");
