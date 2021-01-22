import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String username;
  final String photoUrl;
  final String email;
  final String jobs;
  final String ownerReview;
  final String freelancerReview;
  final double ownerAttitudeRating;
  final double freelancerQualityRating;
  final double freelancerAttitudeRating;
  final double freelancerTimeManagementRating;
  final bool isFreelancer;
  final Timestamp createdAt;

  Review({
    this.id,
    this.username,
    this.photoUrl,
    this.email,
    this.jobs,
    this.isFreelancer,
    this.createdAt,
    this.ownerReview,
    this.freelancerReview,
    this.ownerAttitudeRating,
    this.freelancerQualityRating,
    this.freelancerAttitudeRating,
    this.freelancerTimeManagementRating,
  });

  factory Review.clientFromDocument(Map map) {
    return Review(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      photoUrl: map['photoUrl'],
      isFreelancer: map['isFreelancer'],
      ownerReview: map['ownerReview'],
      freelancerReview: map['freelancerReview'],
      ownerAttitudeRating: map['ownerAttitudeRating'],
      freelancerQualityRating: map['freelancerQualityRating'],
      freelancerAttitudeRating: map['freelancerAttitudeRating'],
      freelancerTimeManagementRating: map['freelancerTimeManagementRating'],
    );
  }
  factory Review.freelancerFromDocument(Map map) {
    return Review(
      id: map['id'],
      username: map['username'],
      photoUrl: map['photoUrl'],
      email: map['email'],
      jobs: map['jobs'],
      isFreelancer: map['isFreelancer'],
      ownerReview: map['ownerReview'],
      freelancerReview: map['freelancerReview'],
      ownerAttitudeRating: map['ownerAttitudeRating'],
      freelancerQualityRating: map['freelancerQualityRating'],
      freelancerAttitudeRating: map['freelancerAttitudeRating'],
      freelancerTimeManagementRating: map['freelancerTimeManagementRating'],
    );
  }
  factory Review.fromDocument(Map map) {
    if (map['isFreelancer'] == true)
      return Review.freelancerFromDocument(map);
    else
      return Review.clientFromDocument(map);
  }
}
