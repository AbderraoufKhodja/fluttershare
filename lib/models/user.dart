import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String displayName;
  final String photoUrl;
  final String username;
  final String email;
  final String bio;
  bool isFreelancer;
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
      this.isFreelancer,
      this.jobId,
      this.category,
      this.subCategory,
      this.jobTitle});

  factory User.clientFromDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        email: doc['email'],
        username: doc['username'],
        photoUrl: doc['photoUrl'],
        displayName: doc['displayName'],
        bio: doc['bio'],
        isFreelancer: doc['isFreelancer'],
        category: doc['category'],
        subCategory: doc['subCategory'],
        jobTitle: doc['jobTitle']);
  }
  factory User.freelancerFromDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        email: doc['email'],
        username: doc['username'],
        photoUrl: doc['photoUrl'],
        displayName: doc['displayName'],
        bio: doc['bio'],
        isFreelancer: doc['isFreelancer'],
        jobId: doc['jobId'],
        category: doc['category'],
        subCategory: doc['subCategory'],
        jobTitle: doc['jobTitle']);
  }
  factory User.fromDocument(DocumentSnapshot doc) {
    if (doc['isFreelancer'] == true)
      return User.freelancerFromDocument(doc);
    else
      return User.clientFromDocument(doc);
  }
}
