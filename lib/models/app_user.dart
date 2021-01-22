import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  String username;
  String googleName;
  String photoUrl;
  String email;
  bool isFreelancer;
  bool teamChoice;
  String professionalPhoto;
  String personalBio;
  String gender;
  String location;
  String birthDate;
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
    this.id,
    this.username,
    this.googleName,
    this.photoUrl,
    this.email,
    this.isFreelancer,
    this.teamChoice,
    this.professionalPhoto,
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
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      googleName: doc['googleName'],
      isFreelancer: doc['isFreelancer'],
      preferences: doc['preferences'],
      reviews: doc['reviews'],
      jobs: doc['jobs'],
      createdAt: doc['createdAt'],
    );
  }
  factory AppUser.freelancerFromDocument(DocumentSnapshot doc) {
    return AppUser(
      id: doc['id'],
      username: doc['username'],
      googleName: doc['googleName'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      isFreelancer: doc['isFreelancer'],
      teamChoice: doc['teamChoice'],
      professionalPhoto: doc['professionalPhoto'],
      personalBio: doc['personalBio'],
      gender: doc['gender'],
      location: doc['location'],
      birthDate: doc['birthDate'],
      professionalCategory: doc['professionalCategory'],
      professionalTitle: doc['professionalTitle'],
      professionalDescription: doc['professionalDescription'],
      globalRate: doc['globalRate'],
      jobsCount: doc['jobsCount'],
      completionRate: doc['completionRate'],
      popularityRate: doc['popularityRate'],
      qualityRating: doc['qualityRate'],
      attitudeRating: doc['attitudeRate'],
      preferences: doc['preferences'],
      reviews: doc['reviews'],
      jobs: doc['jobs'],
      diploma: doc['diploma'],
      licence: doc['licence'],
      certification: doc['certification'],
      language: doc['language'],
      experience: doc['experience'],
      internship: doc['internship'],
      competence: doc['competence'],
      achievement: doc['achievement'],
      recommendation: doc['recommendation'],
      createdAt: doc['createdAt'],
    );
  }
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    if (doc['isFreelancer'] == true)
      return AppUser.freelancerFromDocument(doc);
    else
      return AppUser.clientFromDocument(doc);
  }
}
