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
  final String category;
  final String subCategory;
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
      this.category,
      this.subCategory,
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
        category: doc['category'],
        subCategory: doc['subCategory'],
        jobTitle: doc['jobTitle']);
  }
}
