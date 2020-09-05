import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String username;
  String googleName;
  String photoUrl;
  String email;
  String jobs;
  bool isFreelancer;
  String professionalPhoto;
  String personalBio;
  String gender;
  String location;
  String birthDate;
  String professionalCategory;
  String professionalTitle;
  String professionalDescription;
  String keyWords;
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

  User({
    this.id,
    this.username,
    this.googleName,
    this.photoUrl,
    this.email,
    this.jobs,
    this.isFreelancer,
    this.professionalPhoto,
    this.personalBio,
    this.gender,
    this.location,
    this.birthDate,
    this.professionalCategory,
    this.professionalTitle,
    this.professionalDescription,
    this.keyWords,
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

  factory User.clientFromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      googleName: doc['googleName'],
      isFreelancer: doc['isFreelancer'],
    );
  }
  factory User.freelancerFromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      username: doc['username'],
      googleName: doc['googleName'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      jobs: doc['jobs'],
      isFreelancer: doc['isFreelancer'],
      professionalPhoto: doc['professionalPhoto'],
      personalBio: doc['personalBio'],
      gender: doc['gender'],
      location: doc['location'],
      birthDate: doc['birthDate'],
      professionalCategory: doc['professionalCategory'],
      professionalTitle: doc['professionalTitle'],
      professionalDescription: doc['professionalDescription'],
      keyWords: doc['keyWords'],
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
  factory User.fromDocument(DocumentSnapshot doc) {
    if (doc['isFreelancer'] == true)
      return User.freelancerFromDocument(doc);
    else
      return User.clientFromDocument(doc);
  }
}
