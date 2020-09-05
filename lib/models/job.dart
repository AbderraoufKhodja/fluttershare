import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:khadamat/pages/home.dart';

class Job {
  final String jobId;
  final String jobOwnerId;
  final String jobOwnerName;
  final String ownerEmail;
  final bool isOwnerFreelancer;
  final String professionalTitle;
  final String professionalCategory;
  final String jobDescription;
  final String location;
  final String dateRange;
  final String jobPhotoUrl;
  final String price;
  final Timestamp createdAt;
  final Map applications;
  final bool isCompleted;
  final bool isVacant;
  final bool isOnGoing;

  Job({
    this.jobId,
    this.jobOwnerId,
    this.jobOwnerName,
    this.isOwnerFreelancer,
    this.ownerEmail,
    this.professionalCategory,
    this.professionalTitle,
    this.jobDescription,
    this.location,
    this.dateRange,
    this.jobPhotoUrl,
    this.price,
    this.applications,
    this.isVacant,
    this.isOnGoing,
    this.isCompleted,
    this.createdAt,
  });

  factory Job.fromDocument(DocumentSnapshot doc) {
    return Job(
      jobId: doc['jobId'],
      jobOwnerId: doc['jobOwnerId'],
      jobOwnerName: doc['jobOwnerName'],
      isOwnerFreelancer: doc['isOwnerFreelancer'],
      ownerEmail: doc['ownerEmail'],
      professionalCategory: doc['professionalCategory'],
      professionalTitle: doc['professionalTitle'],
      jobDescription: doc['jobDescription'],
      location: doc['location'],
      dateRange: doc['dateRange'],
      jobPhotoUrl: doc['jobPhotoUrl'],
      price: doc['price'],
      applications: doc['applications'],
      isVacant: doc['isVacant'],
      isOnGoing: doc['isOnGoing'],
      isCompleted: doc['isCompleted'],
      createdAt: doc['createdAt'],
    );
  }
  int getApplicationsCount() {
    // if no likes, return 0
    if (applications == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    applications.values.forEach((val) {
      count += 1;
    });
    return count;
  }

  // Note: To delete job, jobOwnerId and currentUser.id must be equal, so they can be used interchangeably
  deleteJob() async {
    // delete job itself
    jobsRef.document(jobId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete uploaded image for the ost
    storageRef.child("job_$jobId.jpg").delete();
    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .document(jobOwnerId)
        .collection("feedItems")
        .where('jobId', isEqualTo: jobId)
        .getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // then delete all comments
    QuerySnapshot commentsSnapshot =
        await commentsRef.document(jobId).collection('comments').getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleApplyJob() {
    bool _isApplied = applications.containsKey(currentUser.id) &&
        applications[currentUser.id] == null;
    if (_isApplied) {
      jobsRef.document(jobId).updateData({
        'applications.${currentUser.id}': FieldValue.delete()
      }).then((value) => applications.remove(currentUser.id));
      removeApplyFromActivityFeed();
    } else if (!_isApplied) {
      jobsRef
          .document(jobId)
          .updateData({'applications.${currentUser.id}': null}).then(
              (value) => applications[currentUser.id] = null);
      addApplyToActivityFeed();
    }
  }

  addApplyToActivityFeed() {
    // add a notification to the jobOwner's activity feed only if message made by OTHER user (to avoid getting notification for our own mark)
    activityFeedRef
        .document(jobOwnerId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "apply",
      "jobId": jobId,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "applicantId": currentUser.id,
      "applicantName": currentUser.username,
      "userProfileImg": currentUser.photoUrl,
      "createdAt": FieldValue.serverTimestamp(),
      "applications": applications,
    });
    activityFeedRef
        .document(currentUser.id)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "apply",
      "jobId": jobId,
      "googleName": professionalTitle,
      "applicantName": currentUser.username,
      "applicantId": currentUser.id,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "createdAt": FieldValue.serverTimestamp(),
      "applications": applications,
    });
  }

//  addMessageActivityFeed() {
//    // add a notification to the jobOwner's activity feed only if message made by OTHER user (to avoid getting notification for our own mark)
//    bool isNotJobOwner = currentUser.id != jobOwnerId;
//    if (isNotJobOwner) {
//      activityFeedRef
//          .document(jobOwnerId)
//          .collection("feedItems")
//          .document(jobId)
//          .setData({
//        "type": "apply",
//        "jobId": jobId,
//        "professionalTitle": professionalTitle,
//        "jobOwnerName": currentUser.username,
//        "category": category,
//        "subCategory": category,
//        "userId": currentUser.id,
//        "userProfileImg": currentUser.photoUrl,
//        "mediaUrl": mediaUrl,
//        "createdAt": FieldValue.serverTimestamp(),
//        "applications": applications,
//      });
//    }
//  }

  removeApplyFromActivityFeed() {
    activityFeedRef
        .document(jobOwnerId)
        .collection("feedItems")
        .document(jobId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    activityFeedRef
        .document(currentUser.id)
        .collection("feedItems")
        .document(jobId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleEditJob() {
    //TODO implement
  }
  // an jobOwner action
  // TODO: handle futures for acceptation confirmation.
  addAcceptToActivityFeed(
      {@required String applicantId,
      @required String applicantName,
      String jobOwnerId}) async {
    notifyOwnerAccept(jobOwnerId, applicantName, applicantId);

    notifyApplicantAccept(applicantId, jobOwnerId, applicantName);

    handleOpenChat(applicantId: applicantId, applicantName: applicantName);
  }

  Future<void> notifyApplicantAccept(
      String applicantId, String jobOwnerId, String applicantName) {
    return activityFeedRef
        .document(applicantId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "accept",
      "jobId": jobId,
      "ProfessionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "applicantName": applicantName,
      "applicantId": applicantId,
      "createdAt": FieldValue.serverTimestamp(),
      "applications": applications,
    });
  }

  Future<void> notifyOwnerAccept(
      String jobOwnerId, String applicantName, String applicantId) {
    return activityFeedRef
        .document(jobOwnerId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "accept",
      "jobId": jobId,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "applicantName": applicantName,
      "applicantId": applicantId,
      "createdAt": FieldValue.serverTimestamp(),
      "applications": applications,
    });
  }

  addRejectToActivityFeed(
      {@required String applicantId, @required String applicantName}) {
    activityFeedRef
        .document(jobOwnerId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "reject",
      "jobId": jobId,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "applicantName": applicantName,
      "applicantId": applicantId,
      "createdAt": FieldValue.serverTimestamp(),
      "applications": applications,
    });

    activityFeedRef
        .document(applicantId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "reject",
      "jobId": jobId,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "applicantId": applicantId,
      "applicantName": applicantName,
      "createdAt": FieldValue.serverTimestamp(),
      "applications": applications,
    });
  }

  handleOpenChat({String applicantId, String applicantName}) {
    // Create a messaging reference in firestore
    messagesRef
        .document(jobId)
        .collection("messages")
        .document()
        .setData({"type": "open"});
    // Create a userJobs reference in firestore to store a reference to point to
    // the message ids for the applicant that can be used to list the messages.
    usersRef
        .document(applicantId)
        .collection("userJobs")
        .document(jobId)
        .setData({
      "jobId": jobId,
      "jobOwnerId": jobOwnerId,
      "jobOwnerName": jobOwnerName,
      "applicantId": applicantId,
      "applicantName": applicantName,
      "professionalTitle": professionalTitle,
      "applications": applications,
      "createdAt": FieldValue.serverTimestamp(),
    });
    // Create a userJobs reference in firestore to store a reference to point to
    // the message ids for the job jobOwner that can be used to list the messages.
    usersRef
        .document(jobOwnerId)
        .collection("userJobs")
        .document(jobId)
        .setData({
      "jobId": jobId,
      "jobOwnerId": jobOwnerId,
      "jobOwnerName": jobOwnerName,
      "applicantId": applicantId,
      "applicantName": applicantName,
      "professionalTitle": professionalTitle,
      "applications": applications,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
