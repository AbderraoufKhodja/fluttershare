import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:khadamat/models/firestore_field.dart';
import 'package:khadamat/pages/ultils.dart';

class ActivityFeed {
  final String type; // 'apply', 'accept', 'reject', 'hire', 'message'
  final String jobId;
  final String jobChatId;
  final String professionalTitle;
  final String jobTitle;
  final String jobOwnerName;
  final String jobOwnerId;
  final String jobFreelancerName;
  final String jobFreelancerId;
  final String applicantName;
  final String applicantId;
  final String requestOwnerId;
  final String requestOwnerName;
  final String newPrice;
  final String newLocation;
  final String newDateRange;
  final String userProfileImg;
  final String commentData;
  final Timestamp createdAt;
  final DocumentReference feedReference;

  ActivityFeed({
    this.type,
    this.jobId,
    this.professionalTitle,
    this.jobTitle,
    this.jobOwnerName,
    this.jobOwnerId,
    this.jobFreelancerName,
    this.jobFreelancerId,
    this.applicantName,
    this.applicantId,
    this.requestOwnerName,
    this.requestOwnerId,
    this.newPrice,
    this.newLocation,
    this.newDateRange,
    this.userProfileImg,
    this.commentData,
    this.createdAt,
    this.feedReference,
    this.jobChatId,
  });

  factory ActivityFeed.fromDocument(DocumentSnapshot doc) {
    return ActivityFeed(
      type: fieldGetter(document: doc, field: ffActFeedType),
      jobId: fieldGetter(document: doc, field: ffActFeedJobId),
      jobChatId: fieldGetter(document: doc, field: ffActFeedJobChatId),
      professionalTitle: fieldGetter(document: doc, field: ffActFeedProfessionalTitle),
      jobTitle: fieldGetter(document: doc, field: ffActFeedJobTitle),
      jobOwnerName: fieldGetter(document: doc, field: ffActFeedJobOwnerName),
      jobOwnerId: fieldGetter(document: doc, field: ffActFeedJobOwnerId),
      jobFreelancerName: fieldGetter(document: doc, field: ffActFeedJobFreelancerName),
      jobFreelancerId: fieldGetter(document: doc, field: ffActFeedJobFreelancerId),
      applicantName: fieldGetter(document: doc, field: ffActFeedApplicantName),
      applicantId: fieldGetter(document: doc, field: ffActFeedApplicantId),
      requestOwnerName: fieldGetter(document: doc, field: ffActFeedRequestOwnerName),
      requestOwnerId: fieldGetter(document: doc, field: ffActFeedRequestOwnerId),
      newPrice: fieldGetter(document: doc, field: ffActFeedNewPrice),
      newLocation: fieldGetter(document: doc, field: ffActFeedNewLocation),
      newDateRange: fieldGetter(document: doc, field: ffActFeedNewDateRange),
      userProfileImg: fieldGetter(document: doc, field: ffActFeedUserProfileImg),
      createdAt: fieldGetter(document: doc, field: ffActFeedCreatedAt),
      feedReference: fieldGetter(document: doc, field: ffActFeedFeedReference),
    );
  }
}

final FirestoreField ffActFeedType = FirestoreField(name: "type", type: String);
final FirestoreField ffActFeedJobId = FirestoreField(name: "jobId", type: String);
final FirestoreField ffActFeedJobChatId =
    FirestoreField(name: "jobChatId", type: String);
final FirestoreField ffActFeedProfessionalTitle =
    FirestoreField(name: "professionalTitle", type: String);
final FirestoreField ffActFeedJobTitle =
    FirestoreField(name: "jobTitle", type: String);
final FirestoreField ffActFeedJobOwnerName =
    FirestoreField(name: "jobOwnerName", type: String);
final FirestoreField ffActFeedJobOwnerId =
    FirestoreField(name: "jobOwnerId", type: String);
final FirestoreField ffActFeedJobFreelancerName =
    FirestoreField(name: "jobFreelancerName", type: String);
final FirestoreField ffActFeedJobFreelancerId =
    FirestoreField(name: "jobFreelancerId", type: String);
final FirestoreField ffActFeedApplicantName =
    FirestoreField(name: "applicantName", type: String);
final FirestoreField ffActFeedApplicantId =
    FirestoreField(name: "applicantId", type: String);
final FirestoreField ffActFeedRequestOwnerId =
    FirestoreField(name: "requestOwnerId", type: String);
final FirestoreField ffActFeedRequestOwnerName =
    FirestoreField(name: "requestOwnerName", type: String);
final FirestoreField ffActFeedNewPrice =
    FirestoreField(name: "newPrice", type: double);
final FirestoreField ffActFeedNewLocation =
    FirestoreField(name: "newLocation", type: Map);
final FirestoreField ffActFeedNewDateRange =
    FirestoreField(name: "newDateRange", type: Map);
final FirestoreField ffActFeedUserProfileImg =
    FirestoreField(name: "userProfileImg", type: String);
final FirestoreField ffActFeedCommentData =
    FirestoreField(name: "commentData", type: String);
final FirestoreField ffActFeedCreatedAt =
    FirestoreField(name: "createdAt", type: Timestamp);
final FirestoreField ffActFeedFeedReference =
    FirestoreField(name: "feedReference", type: Reference);
