import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  bool hasCard;
  final String jobId;
  final String jobCategory;
  final String jobSubCategory;
  final String jobTitle;

  User(
      {this.id,
      this.username,
      this.email,
      this.photoUrl,
      this.displayName,
      this.bio,
      this.hasCard,
      this.jobId,
      this.jobCategory,
      this.jobSubCategory,
      this.jobTitle});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        email: doc['email'],
        username: doc['username'],
        photoUrl: doc['photoUrl'],
        displayName: doc['displayName'],
        bio: doc['bio'],
        hasCard: doc['hasCard'],
        jobId: doc['jobId'],
        jobCategory: doc['jobCategory'],
        jobSubCategory: doc['jobSubCategory'],
        jobTitle: doc['jobTitle']);
  }
}
