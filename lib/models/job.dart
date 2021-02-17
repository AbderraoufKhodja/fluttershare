import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/pages/ultils.dart';

class Job {
  final String jobId;
  final String jobOwnerId;
  final String jobOwnerName;
  final String jobOwnerEmail;
  String jobFreelancerId;
  String jobFreelancerName;
  String jobFreelancerEmail;
  final bool isOwnerFreelancer;
  final String jobPhotoUrl;
  final String jobTitle;
  final String professionalTitle;
  final String professionalCategory;
  String jobDescription;
  GeoFirePoint location;
  String dateRange;
  String price;
  String newJobDescription;
  GeoFirePoint newLocation;
  String newDateRange;
  String newPrice;
  String ownerReview;
  double ownerAttitudeRating;
  String freelancerReview;
  double freelancerQualityRating;
  double freelancerAttitudeRating;
  double freelancerTimeManagementRating;
  final Map applications;
  final Timestamp createdAt;
  Timestamp jobFreelancerEnrollmentDate;
  Timestamp ownerCompletedAt;
  Timestamp freelancerCompletedAt;
  bool isOwnerCompleted;
  bool isFreelancerCompleted;
  String jobState;
  bool hasFreelancerUpdateRequest;
  bool hasOwnerUpdateRequest;

  Job({
    this.jobId,
    this.jobOwnerId,
    this.jobOwnerName,
    this.jobOwnerEmail,
    this.jobFreelancerId,
    this.jobFreelancerName,
    this.jobFreelancerEmail,
    this.jobFreelancerEnrollmentDate,
    this.isOwnerFreelancer,
    this.jobPhotoUrl,
    this.jobTitle,
    this.professionalCategory,
    this.professionalTitle,
    this.jobDescription,
    this.location,
    this.dateRange,
    this.price,
    this.newJobDescription,
    this.newLocation,
    this.newDateRange,
    this.newPrice,
    this.ownerReview,
    this.ownerAttitudeRating,
    this.freelancerReview,
    this.freelancerQualityRating,
    this.freelancerAttitudeRating,
    this.freelancerTimeManagementRating,
    this.applications,
    this.jobState,
    this.isOwnerCompleted,
    this.isFreelancerCompleted,
    this.hasFreelancerUpdateRequest,
    this.hasOwnerUpdateRequest,
    this.createdAt,
    this.ownerCompletedAt,
    this.freelancerCompletedAt,
  });

  factory Job.fromDocument(DocumentSnapshot doc) {
    //TODO read GeofirePoint object from firebase
    return Job(
      jobId: fieldGetter(document: doc, field: "jobId"),
      jobOwnerId: fieldGetter(document: doc, field: "jobOwnerId"),
      jobOwnerName: fieldGetter(document: doc, field: "jobOwnerName"),
      jobOwnerEmail: fieldGetter(document: doc, field: "jobOwnerEmail"),
      jobFreelancerId: fieldGetter(document: doc, field: "jobFreelancerId"),
      jobFreelancerName: fieldGetter(document: doc, field: "jobFreelancerName"),
      jobFreelancerEmail:
          fieldGetter(document: doc, field: "jobFreelancerEmail"),
      jobFreelancerEnrollmentDate:
          fieldGetter(document: doc, field: "jobFreelancerEnrollmentDate"),
      isOwnerFreelancer: fieldGetter(document: doc, field: "isOwnerFreelancer"),
      jobTitle: fieldGetter(document: doc, field: "jobTitle"),
      jobPhotoUrl: fieldGetter(document: doc, field: "jobPhotoUrl"),
      professionalCategory:
          fieldGetter(document: doc, field: "professionalCategory"),
      professionalTitle: fieldGetter(document: doc, field: "professionalTitle"),
      jobDescription: fieldGetter(document: doc, field: "jobDescription"),
      location: fieldGetter(document: doc, field: "location"),
      dateRange: fieldGetter(document: doc, field: "dateRange"),
      price: fieldGetter(document: doc, field: "price"),
      newJobDescription: fieldGetter(document: doc, field: 'newJobDescription'),
      newLocation: fieldGetter(document: doc, field: 'newLocation'),
      newDateRange: fieldGetter(document: doc, field: 'newDateRange'),
      newPrice: fieldGetter(document: doc, field: 'newPrice'),
      ownerReview: fieldGetter(document: doc, field: 'ownerReview'),
      ownerAttitudeRating:
          fieldGetter(document: doc, field: 'ownerAttitudeRating'),
      freelancerReview: fieldGetter(document: doc, field: 'freelancerReview'),
      freelancerQualityRating:
          fieldGetter(document: doc, field: 'freelancerQualityRating'),
      freelancerAttitudeRating:
          fieldGetter(document: doc, field: 'freelancerAttitudeRating'),
      freelancerTimeManagementRating:
          fieldGetter(document: doc, field: 'timeManagementRating'),
      applications: fieldGetter(document: doc, field: "applications"),
      hasFreelancerUpdateRequest:
          fieldGetter(document: doc, field: "hasFreelancerUpdateRequest"),
      hasOwnerUpdateRequest:
          fieldGetter(document: doc, field: "hasOwnerUpdateRequest"),
      jobState: fieldGetter(document: doc, field: "jobState"),
      isOwnerCompleted: fieldGetter(document: doc, field: "isOwnerCompleted"),
      isFreelancerCompleted:
          fieldGetter(document: doc, field: "isFreelancerCompleted"),
      ownerCompletedAt: fieldGetter(document: doc, field: "ownerCompletedAt"),
      freelancerCompletedAt:
          fieldGetter(document: doc, field: "freelancerCompletedAt"),
      createdAt: fieldGetter(document: doc, field: "createdAt"),
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

  // Note: To delete job, jobOwnerId and currentUser.uid must be equal, so they can be used interchangeably
  Future<void> closeJob({@required String closingReason}) async {
    final bool isJobOwner = currentUser.uid == jobOwnerId;
    if (isJobOwner) {
      jobsRef.doc(jobId).update({"jobState": "closed"});
      usersRef.doc(jobOwnerId).update({
        "jobs.$jobId.state": "closed",
      });
      addDeleteJobFeed(uid: jobOwnerId);

      storageRef.child("job_$jobId.jpg").delete();

      uploadTeamNotification(
          messageText: closingReason, type: "deletJustification");

      if (jobFreelancerId != null)
        usersRef.doc(jobFreelancerId).update({
          "jobs.$jobId.state": "closed",
        });
    }
  }

  Future<void> handleDismissAndReviewFreelancer({
    @required String freelancerReview,
    @required double freelancerQualityRating,
    @required double freelancerAttitudeRating,
    @required double freelancerTimeManagementRating,
  }) async {
    addDismissFeed(
        uid: this.jobOwnerId,
        type: "dismissFreelancer",
        jobFreelancerId: this.jobFreelancerId,
        jobFreelancerName: this.jobFreelancerName);
    addDismissFeed(
        uid: this.jobFreelancerId,
        type: "dismissFreelancer",
        jobFreelancerId: this.jobFreelancerId,
        jobFreelancerName: this.jobFreelancerName);
    uploadTeamNotification(
        messageText: freelancerReview, type: "dismissJustification");
    // Update on firestore
    clearJobFreelancerAndMakeJobVaccant();
    addUserReviewAndUpdateUserJob(
      uid: jobFreelancerId,
      type: "dismiss",
      freelancerReview: freelancerReview,
      freelancerQualityRating: freelancerQualityRating,
      freelancerAttitudeRating: freelancerAttitudeRating,
      freelancerTimeManagementRating: freelancerTimeManagementRating,
    );
  }

  handleApplyJob({
    @required String applicantId,
    @required String applicantName,
  }) {
    // TODO add jobState sanity check
    bool _isApplied = applications.containsKey(applicantId) &&
        applications[applicantId] == null;
    if (_isApplied) {
      jobsRef
          .doc(jobId)
          .update({'applications.$applicantId': FieldValue.delete()}).then(
              (value) => applications.remove(applicantId));
      removeApplyFromActivityFeed(
          applicantId: applicantId, applicantName: applicantName);
    } else if (!_isApplied) {
      jobsRef.doc(jobId).update({'applications.$applicantId': null}).then(
          (value) => applications[applicantId] = null);
      addApplyToActivityFeed(
          applicantId: applicantId, applicantName: applicantName);
    }
  }

  addApplyToActivityFeed({
    @required String applicantId,
    @required String applicantName,
  }) {
    // add a notification to the jobOwner's activity feed only if message made
    // by OTHER user (to avoid getting notification for our own mark)
    addApplicationFeed(
        uid: jobOwnerId,
        type: "apply",
        applicantId: applicantId,
        applicantName: applicantName);
    addApplicationFeed(
        uid: applicantId,
        type: "apply",
        applicantId: applicantId,
        applicantName: applicantName);
  }

  Future<void> removeApplyFromActivityFeed({
    @required String applicantId,
    @required String applicantName,
  }) async {
    activityFeedRef
        .doc(jobOwnerId)
        .collection("feedItems")
        .where("jobId", isEqualTo: jobId)
        .where("type", isEqualTo: "apply")
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      }
    });
    activityFeedRef
        .doc(applicantId)
        .collection("feedItems")
        .where("jobId", isEqualTo: jobId)
        .where("type", isEqualTo: "apply")
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      }
    });
  }

  handleEditJob(BuildContext context) {
    showManageJob(context, jobId: jobId);
  }

  Future<void> handleAcceptApplication({
    @required String applicantId,
    @required String applicantName,
    @required String applicantEmail,
  }) async {
    updateJobApplicationStatue(
            applicantId: applicantId,
            applicantName: applicantName,
            applicantEmail: applicantEmail,
            isAccept: true)
        .then((_) {
      addApplicationFeed(
          uid: jobOwnerId,
          type: "acceptApplication",
          applicantId: applicantId,
          applicantName: applicantName);
      addApplicationFeed(
          uid: applicantId,
          type: "acceptApplication",
          applicantId: applicantId,
          applicantName: applicantName);
      createUserJob(uid: applicantId);
      // create a chat reference on firestore
      openChat(applicantId: applicantId);
    });
  }

  handleRejectApplication(
      {@required String applicantId,
      @required String applicantName,
      @required String applicantEmail}) {
    updateJobApplicationStatue(
        applicantName: "",
        applicantId: "",
        applicantEmail: "",
        isAccept: false);
    addApplicationFeed(
        uid: jobOwnerId,
        type: "rejectApplication",
        applicantId: applicantId,
        applicantName: applicantName);
    addApplicationFeed(
        uid: applicantId,
        type: "rejectApplication",
        applicantId: applicantId,
        applicantName: applicantName);
  }

  Future<void> addApplicationFeed(
      {@required String uid,
      @required String type,
      @required String applicantId,
      @required String applicantName}) async {
    return await activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": type,
      "jobId": jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "applicantId": applicantId,
      "applicantName": applicantName,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addDismissFeed(
      {@required String uid,
      @required String type,
      @required String jobFreelancerId,
      @required String jobFreelancerName}) async {
    return await activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": type,
      "jobId": this.jobId,
      "jobTitle": this.jobTitle,
      "professionalTitle": this.professionalTitle,
      "jobOwnerName": this.jobOwnerName,
      "jobOwnerId": this.jobOwnerId,
      "jobFreelancerId": this.jobFreelancerId,
      "jobFreelancerName": this.jobFreelancerName,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addQuitFeed(
      {@required String uid,
      @required String type,
      @required String jobFreelancerId,
      @required String jobFreelancerName}) async {
    return await activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": type,
      "jobId": this.jobId,
      "jobTitle": this.jobTitle,
      "professionalTitle": this.professionalTitle,
      "jobOwnerName": this.jobOwnerName,
      "jobOwnerId": this.jobOwnerId,
      "jobFreelancerId": this.jobFreelancerId,
      "jobFreelancerName": this.jobFreelancerName,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addDeleteJobFeed({@required String uid}) async {
    return await activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": "deleteJob",
      "jobId": this.jobId,
      "jobTitle": this.jobTitle,
      "professionalTitle": this.professionalTitle,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateJobApplicationStatue(
      {String applicantName = "",
      String applicantId = "",
      String applicantEmail = "",
      @required bool isAccept}) async {
    if (isAccept)
      jobsRef.doc(jobId).update({
        'jobFreelancerId': applicantId,
        'jobFreelancerName': applicantName,
        'jobFreelancerEmail': applicantEmail,
        'jobFreelancerEnrollmentDate': FieldValue.serverTimestamp(),
        'applications.$applicantId': isAccept,
        'jobState': "onGoing",
      }).then((_) {
        jobFreelancerId = applicantId;
        jobFreelancerName = applicantName;
        jobFreelancerEmail = applicantEmail;
        jobFreelancerEnrollmentDate = Timestamp.now();
        applications[applicantId] = isAccept;
        jobState = "onGoing";
      });
    else
      jobsRef.doc(jobId).update({
        'applications.$applicantId': isAccept,
        'jobState': "open",
      }).then((_) {
        applications[applicantId] = isAccept;
        jobState = "open";
      });
  }

  Future<void> createUserJob({@required String uid}) {
    return usersRef.doc(uid).update({
      "jobs.$jobId": {
        "jobId": jobId,
        "jobTitle": jobTitle,
        "professionalTitle": professionalTitle,
        "jobOwnerId": jobOwnerId,
        "jobOwnerName": jobOwnerName,
        "jobState": jobState,
        "createdAt": FieldValue.serverTimestamp(),
        "isOwnerCompleted": false,
        "isFreelancerCompleted": false,
      }
    });
  }

  Future<void> openChat({@required String applicantId}) async {
    messagesRef.doc(jobId).collection(jobOwnerId + "&&" + applicantId).add({
      "type": "open",
      "professionalTitle": professionalTitle,
      "jobTitle": jobTitle,
    });
    usersRef
        .doc(jobOwnerId)
        .collection("userChats")
        .doc(jobOwnerId + "&&" + applicantId)
        .set({
      "jobChatId": jobOwnerId + "&&" + applicantId,
      "jobId": jobId,
      "professionalTitle": professionalTitle,
      "jobTitle": jobTitle,
      "jobOwnerId": jobOwnerId,
      "jobOwnerName": jobOwnerName,
      "createdAt": FieldValue.serverTimestamp(),
    });
    usersRef
        .doc(applicantId)
        .collection("userChats")
        .doc(jobOwnerId + "&&" + applicantId)
        .set({
      "jobChatId": jobOwnerId + "&&" + applicantId,
      "jobId": jobId,
      "professionalTitle": professionalTitle,
      "jobTitle": jobTitle,
      "jobOwnerId": jobOwnerId,
      "jobOwnerName": jobOwnerName,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> freelancerCompleteAndReviewJob({
    @required String ownerReview,
    @required double ownerRating,
  }) async {
    addCompleteAndReviewFeed(uid: jobOwnerId);
    addCompleteAndReviewFeed(uid: jobFreelancerId);

    usersRef.doc(jobOwnerId).update({
      "job.$jobId": {
        "isOwnerCompleted": true,
      },
      "reviews.$jobId": {
        "type": "jobCompleted",
        "jobId": jobId,
        "jobTitle": jobTitle,
        "professionalTitle": professionalTitle,
        "jobOwnerName": jobOwnerName,
        "jobOwnerId": jobOwnerId,
        "ownerReview": ownerReview,
        "ownerRating": ownerRating,
        "createdAt": FieldValue.serverTimestamp(),
      }
    });

    jobsRef.doc(jobId).update({
      "ownerReview": ownerReview,
      "ownerAttitudeRating": ownerRating,
      "isFreelancerCompleted": true,
      "freelancerCompletedAt": FieldValue.serverTimestamp(),
    }).then((value) {
      this.ownerReview = ownerReview;
      this.ownerAttitudeRating = ownerRating;
      isFreelancerCompleted = true;
      freelancerCompletedAt = Timestamp.now();
    });
  }

  Future<void> freelancerQuitAndReviewOwner({
    @required String ownerReview,
    @required double ownerRating,
  }) async {
    addQuitFeed(
        uid: this.jobOwnerId,
        type: "freelancerQuit",
        jobFreelancerId: this.jobFreelancerId,
        jobFreelancerName: this.jobFreelancerName);
    addQuitFeed(
        uid: this.jobFreelancerId,
        type: "freelancerQuit",
        jobFreelancerId: this.jobFreelancerId,
        jobFreelancerName: this.jobFreelancerName);
    uploadTeamNotification(messageText: ownerReview, type: "quitJustification");
    // Update on firestore
    clearJobFreelancerAndMakeJobVaccant();
  }

  Future<void> ownerCompleteAndReviewJob({
    @required String freelancerReview,
    @required double freelancerQualityRating,
    @required double freelancerAttitudeRating,
    @required double freelancerTimeManagementRating,
  }) async {
    addCompleteAndReviewFeed(uid: jobOwnerId);
    addCompleteAndReviewFeed(uid: jobFreelancerId);
    addUserReviewAndUpdateUserJob(
      uid: jobFreelancerId,
      type: "jobCompleted",
      freelancerReview: freelancerReview,
      freelancerQualityRating: freelancerQualityRating,
      freelancerAttitudeRating: freelancerAttitudeRating,
      freelancerTimeManagementRating: freelancerTimeManagementRating,
    );

    jobsRef.doc(jobId).update({
      "freelancerReview": freelancerReview,
      "freelancerQualityRating": freelancerQualityRating,
      "freelancerAttitudeRating": freelancerAttitudeRating,
      "freelancerTimeManagementRating": freelancerTimeManagementRating,
      "isOwnerCompleted": true,
      "ownerCompletedAt": FieldValue.serverTimestamp(),
    }).then((_) {
      this.freelancerReview = freelancerReview;
      this.freelancerQualityRating = freelancerQualityRating;
      this.freelancerAttitudeRating = freelancerAttitudeRating;
      this.freelancerTimeManagementRating = freelancerTimeManagementRating;
      this.isOwnerCompleted = true;
      this.ownerCompletedAt = Timestamp.now();
    });
  }

  Future<void> addCompleteAndReviewFeed({
    @required String uid,
  }) async {
    activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": "jobCompleted",
      "jobId": jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "jobFreelancerId": jobFreelancerId,
      "jobFreelancerName": jobFreelancerName,
      "freelancerReview": freelancerReview,
      "freelancerQualityRating": freelancerQualityRating,
      "freelancerAttitudeRating": freelancerAttitudeRating,
      "freelancerTimeManagementRating": freelancerTimeManagementRating,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addRequestUpdateTermsFeed(
      {@required String uid,
      @required String type,
      @required String requestOwnerName,
      @required String requestOwnerId,
      @required String newPrice,
      @required GeoFirePoint newLocation,
      @required String newDateRange,
      @required String newJobDescription}) {
    return activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": type,
      "jobId": jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "jobFreelancerName": jobFreelancerName,
      "jobFreelancerId": jobFreelancerId,
      "requestOwnerName": requestOwnerName,
      "requestOwnerId": requestOwnerId,
      "newJobDescription": newJobDescription,
      "newPrice": newPrice,
      "newLocation": newLocation.data,
      "newDateRange": newDateRange,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addDecisionUpdateTermsFeed({
    @required String uid,
    @required String type,
    @required String decisionOwnerName,
    @required String decisionOwnerId,
  }) {
    return activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": type,
      "jobId": jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "jobFreelancerName": jobFreelancerName,
      "jobFreelancerId": jobFreelancerId,
      "decisionOwnerName": decisionOwnerName,
      "decisionOwnerId": decisionOwnerId,
      "newJobDescription": newJobDescription,
      "newPrice": newPrice,
      "newLocation": newLocation.data,
      "newDateRange": newDateRange,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptUpdateJobTerms({
    @required String decisionOwnerName,
    @required String decisionOwnerId,
  }) async {
    addDecisionUpdateTermsFeed(
      uid: jobOwnerId,
      type: "acceptTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );
    addDecisionUpdateTermsFeed(
      uid: jobFreelancerId,
      type: "acceptTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );

    jobsRef.doc(jobId).update({
      "jobDescription": newJobDescription,
      "dateRange": newDateRange,
      "location": newLocation.data,
      "price": newPrice,
      "hasFreelancerUpdateRequest": false,
      "hasOwnerUpdateRequest": false,
    }).then((value) {
      jobDescription = newJobDescription;
      dateRange = newDateRange;
      location = newLocation;
      price = newPrice;
      hasFreelancerUpdateRequest = false;
      hasOwnerUpdateRequest = false;
    });
  }

  Future<void> rejectUpdateJobTerms({
    @required String decisionOwnerName,
    @required String decisionOwnerId,
  }) async {
    addDecisionUpdateTermsFeed(
      uid: jobOwnerId,
      type: "rejectTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );
    addDecisionUpdateTermsFeed(
      uid: jobFreelancerId,
      type: "rejectTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );

    jobsRef.doc(jobId).update({
      "newJobDescription": null,
      "newDateRange": null,
      "newLocation": null,
      "newPrice": null,
      "hasFreelancerUpdateRequest": false,
      "hasOwnerUpdateRequest": false,
    }).then((value) {
      newJobDescription = null;
      newDateRange = null;
      newLocation = null;
      newPrice = null;
      hasFreelancerUpdateRequest = false;
      hasOwnerUpdateRequest = false;
    });
  }

  Future<void> requestUpdateJobTermsFeed({
    @required String requestOwnerName,
    @required String requestOwnerId,
    @required String newJobDescription,
    @required String newPrice,
    @required GeoFirePoint newLocation,
    @required String newDateRange,
  }) async {
    addRequestUpdateTermsFeed(
      uid: jobOwnerId,
      type: "updateTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newJobDescription: newJobDescription,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );
    addRequestUpdateTermsFeed(
      uid: jobFreelancerId,
      type: "updateTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newJobDescription: newJobDescription,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );

    final bool isJobFreelancer = jobFreelancerId == currentUser.uid;
    final bool isJobOwner = jobOwnerId == currentUser.uid;
    jobsRef.doc(jobId).update({
      "newJobDescription": newJobDescription,
      "newPrice": newPrice,
      "newLocation": newLocation.data,
      "newDateRange": newDateRange,
      "hasFreelancerUpdateRequest": isJobFreelancer,
      "hasOwnerUpdateRequest": isJobOwner,
    }).then((value) {
      this.newJobDescription = newJobDescription;
      this.newPrice = newPrice;
      this.newLocation = newLocation;
      this.newDateRange = newDateRange;
      this.hasFreelancerUpdateRequest = isJobFreelancer;
      this.hasOwnerUpdateRequest = isJobOwner;
    });
  }

  Future<void> clearJobFreelancerAndMakeJobVaccant() async {
    await jobsRef.doc(jobId).update({
      "jobFreelancerId": null,
      "jobFreelancerName": null,
      "jobFreelancerEmail": null,
      "applications.$jobFreelancerId": false,
      "jobState": "open",
    });
  }

  Future<void> createJob() async {
    jobsRef.doc(jobId).set({
      "jobId": jobId,
      "jobOwnerId": jobOwnerId,
      "jobOwnerName": jobOwnerName,
      "jobOwnerEmail": jobOwnerEmail,
      "jobFreelancerId": jobFreelancerId,
      "jobFreelancerName": jobFreelancerName,
      "jobFreelancerEmail": jobFreelancerEmail,
      "isOwnerFreelancer": isOwnerFreelancer,
      "jobPhotoUrl": jobPhotoUrl,
      "jobTitle": jobTitle,
      "professionalCategory": professionalCategory,
      "professionalTitle": professionalTitle,
      "jobDescription": jobDescription,
      "price": price,
      "location": location.data,
      "dateRange": dateRange,
      "newJobDescription": newJobDescription,
      "newLocation": newLocation.data,
      "newPrice": newPrice,
      "newDateRange": newDateRange,
      "ownerReview": ownerReview,
      "freelancerReview": freelancerReview,
      "freelancerQualityRating": freelancerQualityRating,
      "attitudeRating": freelancerAttitudeRating,
      "timeManagement": freelancerTimeManagementRating,
      "applications": applications,
      "hasFreelancerUpdateRequest": hasFreelancerUpdateRequest,
      "hasOwnerUpdateRequest": hasOwnerUpdateRequest,
      "jobState": jobState,
      "isOwnerCompleted": isOwnerCompleted,
      "isFreelancerCompleted": isFreelancerCompleted,
      "createdAt": FieldValue.serverTimestamp(),
    }).then((value) => createUserJob(uid: jobOwnerId));
  }

  Future<void> disposeCurrentFreelancerAndDeleteJob() async {
    addDisposeFeed(uid: jobOwnerId, type: "dispose");
    addDisposeFeed(uid: jobFreelancerId, type: "dispose");

    jobsRef.doc(jobId).update({
      "applications.$jobFreelancerId": false,
      "jobFreelancerId": null,
      "jobFreelancerName": null,
      "jobFreelancerEmail": null,
      "jobState": true,
      "isOwnerCompleted": false,
      "hasFreelancerUpdateRequest": false,
    }).then((value) {
      applications[jobFreelancerId] = false;
      jobFreelancerId = null;
      jobFreelancerName = null;
      jobFreelancerEmail = null;
      jobState = "open";
      isOwnerCompleted = false;
      hasFreelancerUpdateRequest = false;
    });
  }

  Future<void> addDisposeFeed({@required String uid, @required String type}) {
    return activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": type,
      "jobId": jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "jobFreelancerName": jobFreelancerName,
      "jobFreelancerId": jobFreelancerId,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> uploadTeamNotification(
      {@required String messageText, @required String type}) async {
    complaintRef.doc(currentUser.uid).set({
      "type": type,
      "messageText": messageText,
      "jobId": jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "jobFreelancerName": jobFreelancerName,
      "jobFreelancerId": jobFreelancerId,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addUserReviewAndUpdateUserJob({
    @required String uid,
    @required String type,
    @required String freelancerReview,
    @required double freelancerQualityRating,
    @required double freelancerAttitudeRating,
    @required double freelancerTimeManagementRating,
  }) async {
    AppUser user;
    await usersRef.doc(uid).get().then((doc) {
      user = AppUser.fromDocument(doc);
      double reviewsCount = user.reviews.length.toDouble();
      double jobsCount = user.jobs.length.toDouble();
      double newCompletedJobsCount = 0;
      user.jobs.values.forEach((job) {
        if (job['jobState'] == "jobCompleted") newCompletedJobsCount += 1.0;
      });
      double newCompletionRate = newCompletedJobsCount / jobsCount;
      double newQualityRateAverage = computeNewAverage(
          user.qualityRating, reviewsCount, freelancerQualityRating);
      double newAttitudeRateAverage = computeNewAverage(
          user.attitudeRating, reviewsCount, freelancerAttitudeRating);
      double newTimeManagementRateAverage = computeNewAverage(
          user.timeManagementRating,
          reviewsCount,
          freelancerTimeManagementRating);
      double newGlobalRateAverage = (newQualityRateAverage +
              newAttitudeRateAverage +
              newTimeManagementRateAverage) /
          3;
      usersRef.doc(uid).update({
        "qualityRate": newQualityRateAverage,
        "attitudeRate": newAttitudeRateAverage,
        "timeManagementRate": newTimeManagementRateAverage,
        "globalRate": newGlobalRateAverage,
        "completionRate": newCompletionRate,
        "jobsCount": newCompletedJobsCount,
        "job.$jobId": {
          "jobState": type,
        },
        "reviews.$jobId": {
          "type": type,
          "jobId": jobId,
          "jobTitle": jobTitle,
          "professionalTitle": professionalTitle,
          "jobOwnerName": jobOwnerName,
          "jobOwnerId": jobOwnerId,
          "freelancerReview": freelancerReview,
          "freelancerQualityRating": freelancerQualityRating,
          "freelancerAttitudeRating": freelancerAttitudeRating,
          "freelancerTimeManagementRating": freelancerTimeManagementRating,
          "createdAt": FieldValue.serverTimestamp(),
        }
      });
    });
  }

  double computeNewAverage(
      double currentValue, double length, double newValue) {
    return ((currentValue * length) + newValue) / (length + 1);
  }
}

class JobFirestoreFieldName {
  static String ffnJobId = "ffnJobId";
  static String ffnJobOwnerId = "ffnJobOwnerId";
  static String ffnJobOwnerName = "ffnJobOwnerName";
  static String ffnJobOwnerEmail = "ffnJobOwnerEmail";
  static String ffnJobFreelancerId = "ffnJobFreelancerId";
  static String ffnJobFreelancerName = "ffnJobFreelancerName";
  static String ffnJobFreelancerEmail = "ffnJobFreelancerEmail";
  static String ffnIsOwnerFreelancer = "ffnIsOwnerFreelancer";
  static String ffnJobPhotoUrl = "ffnJobPhotoUrl";
  static String ffnJobTitle = "ffnJobTitle";
  static String ffnProfessionalCategory = "ffnProfessionalCategory";
  static String ffnProfessionalTitle = "ffnProfessionalTitle";
  static String ffnJobDescription = "ffnJobDescription";
  static String ffnPrice = "ffnPrice";
  static String ffnLocation = "ffnLocation";
  static String ffnDateRange = "ffnDateRange";
  static String ffnNewJobDescription = "ffnNewJobDescription";
  static String ffnNewLocation = "ffnNewLocation";
  static String ffnNewPrice = "ffnNewPrice";
  static String ffnNewDateRange = "ffnNewDateRange";
  static String ffnOwnerReview = "ffnOwnerReview";
  static String ffnFreelancerReview = "ffnFreelancerReview";
  static String ffnFreelancerQualityRating = "ffnFreelancerQualityRating";
  static String ffnAttitudeRating = "ffnAttitudeRating";
  static String ffnTimeManagement = "ffnTimeManagement";
  static String ffnApplications = "ffnApplications";
  static String ffnHasFreelancerUpdateRequest = "ffnHasFreelancerUpdateRequest";
  static String ffnHasOwnerUpdateRequest = "ffnHasOwnerUpdateRequest";
  static String jobState = "ffnJobState";
  static String ffnIsOwnerCompleted = "ffnIsOwnerCompleted";
  static String ffnIsFreelancerCompleted = "ffnIsFreelancerCompleted";
  static String ffnCreatedAt = "ffnCreatedAt";
}
