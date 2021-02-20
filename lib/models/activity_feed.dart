import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khadamat/models/firestore_field.dart';

class ActivityFeed {
  final FirestoreField<String>
      type; // 'apply', 'accept', 'reject', 'hire', 'message'
  final FirestoreField<String> jobId;
  final FirestoreField<String> jobChatId;
  final FirestoreField<String> professionalTitle;
  final FirestoreField<String> jobTitle;
  final FirestoreField<String> jobOwnerName;
  final FirestoreField<String> jobOwnerId;
  final FirestoreField<String> jobFreelancerName;
  final FirestoreField<String> jobFreelancerId;
  final FirestoreField<String> applicantName;
  final FirestoreField<String> applicantId;
  final FirestoreField<String> requestOwnerId;
  final FirestoreField<String> requestOwnerName;
  final FirestoreField<String> newPrice;
  final FirestoreField<String> newLocation;
  final FirestoreField<String> newDateRange;
  final FirestoreField<String> userProfileImg;
  final FirestoreField<String> commentData;
  final FirestoreField<Timestamp> createdAt;
  final FirestoreField<DocumentReference> feedReference;

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
      type: FirestoreField<String>.fromDocument(doc: doc, name: "type"),
      jobId: FirestoreField<String>.fromDocument(doc: doc, name: "jobId"),
      jobChatId:
          FirestoreField<String>.fromDocument(doc: doc, name: "jobChatId"),
      professionalTitle: FirestoreField<String>.fromDocument(
          doc: doc, name: "professionalTitle"),
      jobTitle: FirestoreField<String>.fromDocument(doc: doc, name: "jobTitle"),
      jobOwnerName:
          FirestoreField<String>.fromDocument(doc: doc, name: "jobOwnerName"),
      jobOwnerId:
          FirestoreField<String>.fromDocument(doc: doc, name: "jobOwnerId"),
      jobFreelancerName: FirestoreField<String>.fromDocument(
          doc: doc, name: "jobFreelancerName"),
      jobFreelancerId: FirestoreField<String>.fromDocument(
          doc: doc, name: "jobFreelancerId"),
      applicantName:
          FirestoreField<String>.fromDocument(doc: doc, name: "applicantName"),
      applicantId:
          FirestoreField<String>.fromDocument(doc: doc, name: "applicantId"),
      requestOwnerName: FirestoreField<String>.fromDocument(
          doc: doc, name: "requestOwnerName"),
      requestOwnerId:
          FirestoreField<String>.fromDocument(doc: doc, name: "requestOwnerId"),
      newPrice: FirestoreField<String>.fromDocument(doc: doc, name: "newPrice"),
      newLocation:
          FirestoreField<String>.fromDocument(doc: doc, name: "newLocation"),
      newDateRange:
          FirestoreField<String>.fromDocument(doc: doc, name: "newDateRange"),
      userProfileImg:
          FirestoreField<String>.fromDocument(doc: doc, name: "userProfileImg"),
      createdAt:
          FirestoreField<Timestamp>.fromDocument(doc: doc, name: "createdAt"),
      feedReference: FirestoreField<DocumentReference>.fromDocument(
          doc: doc, name: "feedReference"),
    );
  }
}
