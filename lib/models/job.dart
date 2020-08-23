import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:khadamat/pages/home.dart';

class Job {
  final String jobId;
  final String jobCategory;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final String price;
  final String schedule;
  final Timestamp timestamp;
  final Map applications;
  final bool isCompleted;
  final bool isVacant;
  final bool isOnGoing;
  final bool hasAccepted;

  Job({
    this.jobId,
    this.jobCategory,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.price,
    this.schedule,
    this.timestamp,
    this.applications,
    this.isVacant,
    this.isOnGoing,
    this.isCompleted,
    this.hasAccepted,
  });

  factory Job.fromDocument(DocumentSnapshot doc) {
    return Job(
      jobId: doc['jobId'],
      jobCategory: doc['jobCategory'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      price: doc['price'],
      schedule: doc['schedule'],
      timestamp: doc['timestamp'],
      applications: doc['applications'],
      isVacant: doc['isVacant'],
      isOnGoing: doc['isOnGoing'],
      isCompleted: doc['isCompleted'],
      hasAccepted: doc["hasAccepted"],
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

  // Note: To delete job, ownerId and currentUser.id must be equal, so they can be used interchangeably
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
        .document(ownerId)
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
        .document(ownerId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "apply",
      "jobId": jobId,
      "ownerName": username,
      "applicantId": currentUser.id,
      "applicantName": currentUser.username,
      "jobCategory": jobCategory,
      "userProfileImg": currentUser.photoUrl,
      "mediaUrl": mediaUrl,
      "timestamp": timestamp,
      "applications": applications,
    });
    activityFeedRef
        .document(currentUser.id)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "apply",
      "jobId": jobId,
      "applicantName":
          currentUser.username, // Apply is only done by currentUser
      "applicantId": currentUser.id,
      "ownerName": username,
      "jobCategory": jobCategory,
      "userProfileImg": currentUser.photoUrl,
      "mediaUrl": mediaUrl,
      "timestamp": timestamp,
      "applications": applications,
    });
  }

  addMessageActivityFeed() {
    // add a notification to the jobOwner's activity feed only if message made by OTHER user (to avoid getting notification for our own mark)
    bool isNotJobOwner = currentUser.id != ownerId;
    if (isNotJobOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(jobId)
          .setData({
        "type": "apply",
        "ownerName": currentUser.username,
        "jobCategory": jobCategory,
        "userId": currentUser.id,
        "userProfileImg": currentUser.photoUrl,
        "jobId": jobId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
        "applications": applications,
      });
    }
  }

  removeApplyFromActivityFeed() {
    activityFeedRef
        .document(ownerId)
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
  // an owner action
  addAcceptToActivityFeed({@required String applicantId}) {
    activityFeedRef
        .document(ownerId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "accept",
      "ownerName": username,
      "applicantId": applicantId,
      "jobCategory": jobCategory,
      "jobOwnerId": currentUser.id,
      "userProfileImg": currentUser.photoUrl,
      "jobId": jobId,
      "mediaUrl": mediaUrl,
      "timestamp": timestamp,
      "applications": applications,
    });
    activityFeedRef
        .document(applicantId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "accept",
      "jobId": jobId,
      "ownerName": username,
      "jobOwnerId": currentUser.id,
      "applicantId": applicantId,
      "userProfileImg": currentUser.photoUrl,
      "jobCategory": jobCategory,
      "mediaUrl": mediaUrl,
      "timestamp": timestamp,
      "applications": applications,
    });
    hiresRef
        .document(applicantId)
        .collection("usersJobs")
        .document(jobId)
        .setData({
      "completed": null,
      "jobOwnerId": currentUser.id,
    });
  }

  addRejectToActivityFeed({@required String applicantId}) {
    activityFeedRef
        .document(ownerId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "reject",
      "ownerName": username,
      "ownerId": ownerId,
      "applicantId": applicantId,
      "jobCategory": jobCategory,
      "userProfileImg": currentUser.photoUrl,
      "jobId": jobId,
      "mediaUrl": mediaUrl,
      "timestamp": timestamp,
      "applications": applications,
    });

    activityFeedRef
        .document(applicantId)
        .collection("feedItems")
        .document(jobId)
        .setData({
      "type": "reject",
      "ownerName": username,
      "ownerId": ownerId,
      "applicantId": applicantId,
      "jobCategory": jobCategory,
      "userProfileImg": currentUser.photoUrl,
      "jobId": jobId,
      "mediaUrl": mediaUrl,
      "timestamp": timestamp,
      "applications": applications,
    });
  }
}
