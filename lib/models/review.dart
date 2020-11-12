import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  String username;
  String photoUrl;
  String email;
  String jobs;
  String ownerReview;
  String freelancerReview;
  double ownerMannersRating;
  double freelancerJobQualityRating;
  double freelancerMannersRating;
  double freelancerTimeManagementRating;
  bool isFreelancer;
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
    this.ownerMannersRating,
    this.freelancerJobQualityRating,
    this.freelancerMannersRating,
    this.freelancerTimeManagementRating,
  });

  factory Review.clientFromDocument(DocumentSnapshot doc) {
    return Review(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      isFreelancer: doc['isFreelancer'],
      ownerReview: doc['ownerReview'],
      freelancerReview: doc['freelancerReview'],
      ownerMannersRating: doc['ownerMannersRating'],
      freelancerJobQualityRating: doc['freelancerJobQualityRating'],
      freelancerMannersRating: doc['freelancerMannersRating'],
      freelancerTimeManagementRating: doc['freelancerTimeManagementRating'],
    );
  }
  factory Review.freelancerFromDocument(DocumentSnapshot doc) {
    return Review(
      id: doc['id'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      jobs: doc['jobs'],
      isFreelancer: doc['isFreelancer'],
      ownerReview: doc['ownerReview'],
      freelancerReview: doc['freelancerReview'],
      ownerMannersRating: doc['ownerMannersRating'],
      freelancerJobQualityRating: doc['freelancerJobQualityRating'],
      freelancerMannersRating: doc['freelancerMannersRating'],
      freelancerTimeManagementRating: doc['freelancerTimeManagementRating'],
    );
  }
  factory Review.fromDocument(DocumentSnapshot doc) {
    if (doc['isFreelancer'] == true)
      return Review.freelancerFromDocument(doc);
    else
      return Review.clientFromDocument(doc);
  }
}
