import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/models/firestore_field.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/pages/ultils.dart';

class Job {
  final FirestoreField<String> jobId;
  final FirestoreField<String> jobOwnerId;
  final FirestoreField<String> jobOwnerName;
  final FirestoreField<String> jobOwnerEmail;
  final FirestoreField<String> jobFreelancerId;
  final FirestoreField<String> jobFreelancerName;
  final FirestoreField<String> jobFreelancerEmail;
  final FirestoreField<bool> isOwnerFreelancer;
  final FirestoreField<String> jobPhotoUrl;
  final FirestoreField<String> jobTitle;
  final FirestoreField<String> professionalTitle;
  final FirestoreField<String> professionalCategory;
  final FirestoreField<String> jobDescription;
  final FirestoreField<Map> location;
  final FirestoreField<String> dateRange;
  final FirestoreField<String> price;
  final FirestoreField<String> newJobDescription;
  final FirestoreField<Map> newLocation;
  final FirestoreField<String> newDateRange;
  final FirestoreField<String> newPrice;
  final FirestoreField<String> ownerReview;
  final FirestoreField<double> ownerAttitudeRate;
  final FirestoreField<String> freelancerReview;
  final FirestoreField<double> freelancerQualityRate;
  final FirestoreField<double> freelancerAttitudeRate;
  final FirestoreField<double> freelancerTimeManagementRate;
  final FirestoreField<Map> applications;
  final FirestoreField<Timestamp> createdAt;
  final FirestoreField<Timestamp> jobFreelancerEnrollmentDate;
  final FirestoreField<Timestamp> ownerCompletedAt;
  final FirestoreField<Timestamp> freelancerCompletedAt;
  final FirestoreField<bool> isOwnerCompleted;
  final FirestoreField<bool> isFreelancerCompleted;
  final FirestoreField<String> jobState;
  final FirestoreField<bool> hasFreelancerUpdateRequest;
  final FirestoreField<bool> hasOwnerUpdateRequest;

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
    this.ownerAttitudeRate,
    this.freelancerReview,
    this.freelancerQualityRate,
    this.freelancerAttitudeRate,
    this.freelancerTimeManagementRate,
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
      jobId: FirestoreField<String>.fromDocument(doc: doc, name: "this.jobId"),
      jobOwnerId: FirestoreField<String>.fromDocument(
          doc: doc, name: "this.jobOwnerId"),
      jobOwnerName:
          FirestoreField<String>.fromDocument(doc: doc, name: "jobOwnerName"),
      jobOwnerEmail:
          FirestoreField<String>.fromDocument(doc: doc, name: "jobOwnerEmail"),
      jobFreelancerId: FirestoreField<String>.fromDocument(
          doc: doc, name: "jobFreelancerId"),
      jobFreelancerName: FirestoreField<String>.fromDocument(
          doc: doc, name: "jobFreelancerName"),
      jobFreelancerEmail: FirestoreField<String>.fromDocument(
          doc: doc, name: "jobFreelancerEmail"),
      jobFreelancerEnrollmentDate: FirestoreField<Timestamp>.fromDocument(
          doc: doc, name: "jobFreelancerEnrollmentDate"),
      isOwnerFreelancer: FirestoreField<bool>.fromDocument(
          doc: doc, name: "isOwnerFreelancer"),
      jobTitle: FirestoreField<String>.fromDocument(doc: doc, name: "jobTitle"),
      jobPhotoUrl:
          FirestoreField<String>.fromDocument(doc: doc, name: "jobPhotoUrl"),
      professionalCategory: FirestoreField<String>.fromDocument(
          doc: doc, name: "professionalCategory"),
      professionalTitle: FirestoreField<String>.fromDocument(
          doc: doc, name: "professionalTitle"),
      jobDescription:
          FirestoreField<String>.fromDocument(doc: doc, name: "jobDescription"),
      location: FirestoreField<Map>.fromDocument(doc: doc, name: "location"),
      dateRange:
          FirestoreField<String>.fromDocument(doc: doc, name: "dateRange"),
      price: FirestoreField<String>.fromDocument(doc: doc, name: "price"),
      newJobDescription: FirestoreField<String>.fromDocument(
          doc: doc, name: "newJobDescription"),
      newLocation:
          FirestoreField<Map>.fromDocument(doc: doc, name: "newLocation"),
      newDateRange:
          FirestoreField<String>.fromDocument(doc: doc, name: "newDateRange"),
      newPrice: FirestoreField<String>.fromDocument(doc: doc, name: "newPrice"),
      ownerReview:
          FirestoreField<String>.fromDocument(doc: doc, name: "ownerReview"),
      ownerAttitudeRate: FirestoreField<double>.fromDocument(
          doc: doc, name: "ownerAttitudeRate"),
      freelancerReview: FirestoreField<String>.fromDocument(
          doc: doc, name: "freelancerReview"),
      freelancerQualityRate: FirestoreField<double>.fromDocument(
          doc: doc, name: "freelancerQualityRate"),
      freelancerAttitudeRate: FirestoreField<double>.fromDocument(
          doc: doc, name: "freelancerAttitudeRate"),
      freelancerTimeManagementRate: FirestoreField<double>.fromDocument(
          doc: doc, name: "freelancerTimeManagementRate"),
      applications:
          FirestoreField<Map>.fromDocument(doc: doc, name: "applications"),
      hasFreelancerUpdateRequest: FirestoreField<bool>.fromDocument(
          doc: doc, name: "hasFreelancerUpdateRequest"),
      hasOwnerUpdateRequest: FirestoreField<bool>.fromDocument(
          doc: doc, name: "hasOwnerUpdateRequest"),
      jobState: FirestoreField<String>.fromDocument(doc: doc, name: "jobState"),
      isOwnerCompleted:
          FirestoreField<bool>.fromDocument(doc: doc, name: "isOwnerCompleted"),
      isFreelancerCompleted: FirestoreField<bool>.fromDocument(
          doc: doc, name: "isFreelancerCompleted"),
      ownerCompletedAt: FirestoreField<Timestamp>.fromDocument(
          doc: doc, name: "ownerCompletedAt"),
      freelancerCompletedAt: FirestoreField<Timestamp>.fromDocument(
          doc: doc, name: "freelancerCompletedAt"),
      createdAt:
          FirestoreField<Timestamp>.fromDocument(doc: doc, name: "createdAt"),
    );
  }
  int getApplicationsCount() {
    // if no likes, return 0
    if (applications == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    applications.value.values.forEach((val) {
      count += 1;
    });
    return count;
  }

  // Note: To delete job, this.jobOwnerId and currentUser.uid.value must be equal, so they can be used interchangeably
  Future<void> closeJob({@required String closingReason}) async {
    final bool isJobOwner = currentUser.uid.value == this.jobOwnerId.value;
    if (isJobOwner) {
      jobsRef.doc(this.jobId.value).update({"jobState": "closed"});
      usersRef.doc(this.jobOwnerId.value).update({
        "jobs.$this.jobId.state": "closed",
      });
      addDeleteJobFeed(uid: this.jobOwnerId.value);

      storageRef.child("job_$this.jobId.jpg").delete();

      uploadTeamNotification(
          messageText: closingReason, type: "deletJustification");

      if (jobFreelancerId != null)
        usersRef.doc(jobFreelancerId.value).update({
          "jobs.$this.jobId.state": "closed",
        });
    }
  }

  Future<void> handleDismissAndReviewFreelancer({
    @required String freelancerReview,
    @required double freelancerQualityRate,
    @required double freelancerAttitudeRate,
    @required double freelancerTimeManagementRate,
  }) async {
    addDismissFeed(
        uid: this.jobOwnerId.value,
        type: "dismissFreelancer",
        jobFreelancerId: this.jobFreelancerId.value,
        jobFreelancerName: this.jobFreelancerName.value);
    addDismissFeed(
        uid: this.jobFreelancerId.value,
        type: "dismissFreelancer",
        jobFreelancerId: this.jobFreelancerId.value,
        jobFreelancerName: this.jobFreelancerName.value);
    uploadTeamNotification(
        messageText: freelancerReview, type: "dismissJustification");
    // Update on firestore
    clearJobFreelancerAndMakeJobVaccant();
    addUserReviewAndUpdateUserJob(
      uid: jobFreelancerId.value,
      type: "dismiss",
      freelancerReview: freelancerReview,
      freelancerQualityRate: freelancerQualityRate,
      freelancerAttitudeRate: freelancerAttitudeRate,
      freelancerTimeManagementRate: freelancerTimeManagementRate,
    );
  }

  handleApplyJob({
    @required String applicantId,
    @required String applicantName,
  }) {
    // TODO add jobState sanity check
    bool _isApplied = applications.value.containsKey(applicantId) &&
        applications.value[applicantId] == null;
    if (_isApplied) {
      jobsRef
          .doc(this.jobId.value)
          .update({'applications.$applicantId': FieldValue.delete()}).then(
              (value) => applications.value.remove(applicantId));
      removeApplyFromActivityFeed(
          applicantId: applicantId, applicantName: applicantName);
    } else if (!_isApplied) {
      jobsRef
          .doc(this.jobId.value)
          .update({'applications.$applicantId': null}).then(
              (value) => applications.value[applicantId] = null);
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
        uid: this.jobOwnerId.value,
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
        .doc(this.jobOwnerId.value)
        .collection("feedItems")
        .where("this.jobId", isEqualTo: this.jobId.value)
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
        .where("this.jobId", isEqualTo: this.jobId)
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
    showManageJob(context, jobId: this.jobId.value);
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
          uid: this.jobOwnerId.value,
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
        uid: this.jobOwnerId.value,
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
      this.jobId.name: this.jobId.value,
      this.jobTitle.name: this.jobTitle.value,
      this.professionalTitle.name: this.professionalTitle.value,
      this.jobOwnerName.name: this.jobOwnerName.value,
      this.jobOwnerId.name: this.jobOwnerId.value,
      applicantId: applicantId,
      applicantName: applicantName,
      "read": false,
      this.createdAt.name: FieldValue.serverTimestamp(),
    });
  }

  Future<void> addDismissFeed(
      {@required String uid,
      @required String type,
      @required String jobFreelancerId,
      @required String jobFreelancerName}) async {
    return await activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": type,
      this.jobId.name: this.jobId.value,
      this.jobTitle.name: this.jobTitle.value,
      this.professionalTitle.name: this.professionalTitle.value,
      this.jobOwnerName.name: this.jobOwnerName.value,
      this.jobOwnerId.name: this.jobOwnerId.value,
      this.jobFreelancerId.name: this.jobFreelancerId.value,
      this.jobFreelancerName.name: this.jobFreelancerName.value,
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
      "this.jobId": this.jobId.value,
      "jobTitle": this.jobTitle.value,
      "professionalTitle": this.professionalTitle.value,
      "jobOwnerName": this.jobOwnerName.value,
      "this.jobOwnerId": this.jobOwnerId.value,
      "jobFreelancerId": this.jobFreelancerId.value,
      "jobFreelancerName": this.jobFreelancerName.value,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addDeleteJobFeed({@required String uid}) async {
    return await activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": "deleteJob",
      "this.jobId": this.jobId.value,
      "jobTitle": this.jobTitle.value,
      "professionalTitle": this.professionalTitle.value,
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
      jobsRef.doc(this.jobId.value).update({
        'jobFreelancerId': applicantId,
        'jobFreelancerName': applicantName,
        'jobFreelancerEmail': applicantEmail,
        'jobFreelancerEnrollmentDate': FieldValue.serverTimestamp(),
        'applications.$applicantId': isAccept,
        'jobState': "onGoing",
      }).then((_) {
        jobFreelancerId.value = applicantId;
        jobFreelancerName.value = applicantName;
        jobFreelancerEmail.value = applicantEmail;
        jobFreelancerEnrollmentDate.value = Timestamp.now();
        applications.value[applicantId] = isAccept;
        jobState.value = "onGoing";
      });
    else
      jobsRef.doc(this.jobId.value).update({
        'applications.$applicantId': isAccept,
        'jobState': "open",
      }).then((_) {
        this.applications.value[applicantId] = isAccept;
        this.jobState.value = "open";
      });
  }

  Future<void> createUserJob({@required String uid}) {
    return usersRef.doc(uid).update({
      "jobs.$this.jobId": {
        this.jobId.name: this.jobId,
        "jobTitle": jobTitle,
        "professionalTitle": professionalTitle,
        "this.jobOwnerId": this.jobOwnerId,
        "jobOwnerName": jobOwnerName,
        "jobState": jobState,
        "createdAt": FieldValue.serverTimestamp(),
        "isOwnerCompleted": false,
        "isFreelancerCompleted": false,
      }
    });
  }

  Future<void> openChat({@required String applicantId}) async {
    messagesRef
        .doc(this.jobId.value)
        .collection(this.jobOwnerId.value + "&&" + applicantId)
        .add({
      "type": "open",
      "professionalTitle": professionalTitle,
      "jobTitle": jobTitle,
    });
    usersRef
        .doc(this.jobOwnerId.value)
        .collection("userChats")
        .doc(this.jobOwnerId.value + "&&" + applicantId)
        .set({
      "jobChatId": this.jobOwnerId.value + "&&" + applicantId,
      "this.jobId": this.jobId,
      "professionalTitle": professionalTitle,
      "jobTitle": jobTitle,
      "this.jobOwnerId": this.jobOwnerId,
      "jobOwnerName": jobOwnerName,
      "createdAt": FieldValue.serverTimestamp(),
    });
    usersRef
        .doc(applicantId)
        .collection("userChats")
        .doc(this.jobOwnerId.value + "&&" + applicantId)
        .set({
      "jobChatId": this.jobOwnerId.value + "&&" + applicantId,
      "this.jobId": this.jobId,
      "professionalTitle": professionalTitle,
      "jobTitle": jobTitle,
      "this.jobOwnerId": this.jobOwnerId,
      "jobOwnerName": jobOwnerName,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> freelancerCompleteAndReviewJob({
    @required String ownerReview,
    @required double ownerRate,
  }) async {
    addCompleteAndReviewFeed(uid: this.jobOwnerId.value);
    addCompleteAndReviewFeed(uid: this.jobFreelancerId.value);

    usersRef.doc(this.jobOwnerId.value).update({
      "job.$this.jobId": {
        "isOwnerCompleted": true,
      },
      "reviews.$this.jobId": {
        "type": "jobCompleted",
        "this.jobId": this.jobId,
        "jobTitle": this.jobTitle,
        "professionalTitle": this.professionalTitle,
        "jobOwnerName": this.jobOwnerName,
        "this.jobOwnerId": this.jobOwnerId,
        "ownerReview": ownerReview,
        "ownerRate": ownerRate,
        "createdAt": FieldValue.serverTimestamp(),
      }
    });

    jobsRef.doc(this.jobId.value).update({
      "ownerReview": ownerReview,
      "ownerAttitudeRate": ownerRate,
      "isFreelancerCompleted": true,
      "freelancerCompletedAt": FieldValue.serverTimestamp(),
    }).then((value) {
      this.ownerReview.value = ownerReview;
      this.ownerAttitudeRate.value = ownerRate;
      this.isFreelancerCompleted.value = true;
      this.freelancerCompletedAt.value = Timestamp.now();
    });
  }

  Future<void> freelancerQuitAndReviewOwner({
    @required String ownerReview,
    @required double ownerRate,
  }) async {
    addQuitFeed(
        uid: this.jobOwnerId.value,
        type: "freelancerQuit",
        jobFreelancerId: this.jobFreelancerId.value,
        jobFreelancerName: this.jobFreelancerName.value);
    addQuitFeed(
        uid: this.jobFreelancerId.value,
        type: "freelancerQuit",
        jobFreelancerId: this.jobFreelancerId.value,
        jobFreelancerName: this.jobFreelancerName.value);
    uploadTeamNotification(messageText: ownerReview, type: "quitJustification");
    // Update on firestore
    clearJobFreelancerAndMakeJobVaccant();
  }

  Future<void> ownerCompleteAndReviewJob({
    @required String freelancerReview,
    @required double freelancerQualityRate,
    @required double freelancerAttitudeRate,
    @required double freelancerTimeManagementRate,
  }) async {
    addCompleteAndReviewFeed(uid: this.jobOwnerId.value);
    addCompleteAndReviewFeed(uid: this.jobFreelancerId.value);
    addUserReviewAndUpdateUserJob(
      uid: this.jobFreelancerId.value,
      type: "jobCompleted",
      freelancerReview: freelancerReview,
      freelancerQualityRate: freelancerQualityRate,
      freelancerAttitudeRate: freelancerAttitudeRate,
      freelancerTimeManagementRate: freelancerTimeManagementRate,
    );

    jobsRef.doc(this.jobId.value).update({
      "freelancerReview": freelancerReview,
      "freelancerQualityRate": freelancerQualityRate,
      "freelancerAttitudeRate": freelancerAttitudeRate,
      "freelancerTimeManagementRate": freelancerTimeManagementRate,
      "isOwnerCompleted": true,
      "ownerCompletedAt": FieldValue.serverTimestamp(),
    }).then((_) {
      this.freelancerReview.value = freelancerReview;
      this.freelancerQualityRate.value = freelancerQualityRate;
      this.freelancerAttitudeRate.value = freelancerAttitudeRate;
      this.freelancerTimeManagementRate.value = freelancerTimeManagementRate;
      this.isOwnerCompleted.value = true;
      this.ownerCompletedAt.value = Timestamp.now();
    });
  }

  Future<void> addCompleteAndReviewFeed({
    @required String uid,
  }) async {
    activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": "jobCompleted",
      "this.jobId": this.jobId.value,
      "jobTitle": this.jobTitle.value,
      "professionalTitle": this.professionalTitle.value,
      "jobOwnerName": this.jobOwnerName.value,
      "this.jobOwnerId": this.jobOwnerId,
      "jobFreelancerId": this.jobFreelancerId.value,
      "jobFreelancerName": this.jobFreelancerName.value,
      "freelancerReview": this.freelancerReview.value,
      "freelancerQualityRate": this.freelancerQualityRate.value,
      "freelancerAttitudeRate": this.freelancerAttitudeRate.value,
      "freelancerTimeManagementRate": this.freelancerTimeManagementRate.value,
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
      @required Map newLocation,
      @required String newDateRange,
      @required String newJobDescription}) {
    return activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": type,
      "this.jobId": this.jobId.value,
      "jobTitle": this.jobTitle.value,
      "professionalTitle": this.professionalTitle.value,
      "jobOwnerName": this.jobOwnerName.value,
      "this.jobOwnerId": this.jobOwnerId.value,
      "jobFreelancerName": this.jobFreelancerName.value,
      "jobFreelancerId": this.jobFreelancerId.value,
      "requestOwnerName": requestOwnerName,
      "requestOwnerId": requestOwnerId,
      "newJobDescription": newJobDescription,
      "newPrice": newPrice,
      "newLocation": newLocation,
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
      this.jobId.name: this.jobId.value,
      this.jobTitle.name: this.jobTitle.value,
      this.professionalTitle.name: this.professionalTitle.value,
      this.jobOwnerName.name: this.jobOwnerName.value,
      this.jobOwnerId.name: this.jobOwnerId.value,
      this.jobFreelancerName.name: this.jobFreelancerName.value,
      this.jobFreelancerId.name: this.jobFreelancerId.value,
      "decisionOwnerName": decisionOwnerName,
      "decisionOwnerId": decisionOwnerId,
      this.newJobDescription.name: this.newJobDescription.value,
      this.newPrice.name: this.newPrice.value,
      this.newLocation.name: this.newLocation.value,
      this.newDateRange.name: this.newDateRange.value,
      "read": false,
      this.createdAt.name: FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptUpdateJobTerms({
    @required String decisionOwnerName,
    @required String decisionOwnerId,
  }) async {
    addDecisionUpdateTermsFeed(
      uid: this.jobOwnerId.value,
      type: "acceptTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );
    addDecisionUpdateTermsFeed(
      uid: this.jobFreelancerId.value,
      type: "acceptTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );

    jobsRef.doc(this.jobId.value).update({
      this.jobDescription.name: this.newJobDescription.value,
      this.dateRange.name: this.newDateRange.value,
      this.location.name: this.newLocation.value,
      this.price.name: this.newPrice.value,
      this.hasFreelancerUpdateRequest.name: false,
      this.hasOwnerUpdateRequest.name: false,
    }).then((value) {
      this.jobDescription.value = this.newJobDescription.value;
      this.dateRange.value = this.newDateRange.value;
      this.location.value = this.newLocation.value;
      this.price.value = this.newPrice.value;
      this.hasFreelancerUpdateRequest.value = false;
      this.hasOwnerUpdateRequest.value = false;
    });
  }

  Future<void> rejectUpdateJobTerms({
    @required String decisionOwnerName,
    @required String decisionOwnerId,
  }) async {
    addDecisionUpdateTermsFeed(
      uid: this.jobOwnerId.value,
      type: "rejectTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );
    addDecisionUpdateTermsFeed(
      uid: jobFreelancerId.value,
      type: "rejectTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );

    jobsRef.doc(this.jobId.value).update({
      this.newJobDescription.name: null,
      this.newDateRange.name: null,
      this.newLocation.name: null,
      this.newPrice.name: null,
      this.hasFreelancerUpdateRequest.name: false,
      this.hasOwnerUpdateRequest.name: false,
    }).then((value) {
      this.newJobDescription.value = null;
      this.newDateRange.value = null;
      this.newLocation.value = null;
      this.newPrice.value = null;
      this.hasFreelancerUpdateRequest.value = false;
      this.hasOwnerUpdateRequest.value = false;
    });
  }

  Future<void> requestUpdateJobTermsFeed({
    @required String requestOwnerName,
    @required String requestOwnerId,
    @required String newJobDescription,
    @required String newPrice,
    @required Map newLocation,
    @required String newDateRange,
  }) async {
    addRequestUpdateTermsFeed(
      uid: this.jobOwnerId.value,
      type: "updateTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newJobDescription: newJobDescription,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );
    addRequestUpdateTermsFeed(
      uid: this.jobFreelancerId.value,
      type: "updateTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newJobDescription: newJobDescription,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );

    final bool isJobFreelancer =
        this.jobFreelancerId.value == currentUser.uid.value;
    final bool isJobOwner = this.jobOwnerId.value == currentUser.uid.value;
    jobsRef.doc(this.jobId.value).update({
      "newJobDescription": newJobDescription,
      "newPrice": newPrice,
      "newLocation": newLocation,
      "newDateRange": newDateRange,
      "hasFreelancerUpdateRequest": isJobFreelancer,
      "hasOwnerUpdateRequest": isJobOwner,
    }).then((value) {
      this.newJobDescription.value = newJobDescription;
      this.newPrice.value = newPrice;
      this.newLocation.value = newLocation;
      this.newDateRange.value = newDateRange;
      this.hasFreelancerUpdateRequest.value = isJobFreelancer;
      this.hasOwnerUpdateRequest.value = isJobOwner;
    });
  }

  Future<void> clearJobFreelancerAndMakeJobVaccant() async {
    await jobsRef.doc(this.jobId.value).update({
      this.jobFreelancerId.name: null,
      this.jobFreelancerName.name: null,
      this.jobFreelancerEmail.name: null,
      "applications.$jobFreelancerId": false,
      this.jobState.name: "open",
    });
  }

  Future<void> createJob() async {
    jobsRef.doc(this.jobId.value).set({
      this.jobId.name: this.jobId.value,
      this.jobOwnerId.name: this.jobOwnerId.value,
      this.jobOwnerName.name: this.jobOwnerName.value,
      this.jobOwnerEmail.name: this.jobOwnerEmail.value,
      this.jobFreelancerId.name: this.jobFreelancerId.value,
      this.jobFreelancerName.name: this.jobFreelancerName.value,
      this.jobFreelancerEmail.name: this.jobFreelancerEmail.value,
      this.isOwnerFreelancer.name: this.isOwnerFreelancer.value,
      this.jobPhotoUrl.name: this.jobPhotoUrl.value,
      this.jobTitle.name: this.jobTitle.value,
      this.professionalCategory.name: this.professionalCategory.value,
      this.professionalTitle.name: this.professionalTitle.value,
      this.jobDescription.name: this.jobDescription.value,
      this.price.name: this.price.value,
      this.location.name: this.location.value,
      this.dateRange.name: this.dateRange.value,
      this.newJobDescription.name: this.newJobDescription.value,
      this.newLocation.name: this.newLocation.value,
      this.newPrice.name: this.newPrice.value,
      this.newDateRange.name: this.newDateRange.value,
      this.ownerReview.name: this.ownerReview.value,
      this.freelancerReview.name: this.freelancerReview.value,
      this.freelancerQualityRate.name: this.freelancerQualityRate.value,
      this.freelancerAttitudeRate.name: this.freelancerAttitudeRate.value,
      this.freelancerTimeManagementRate.name:
          this.freelancerTimeManagementRate.value,
      this.applications.name: this.applications.value,
      this.hasFreelancerUpdateRequest.name:
          this.hasFreelancerUpdateRequest.value,
      this.hasOwnerUpdateRequest.name: this.hasOwnerUpdateRequest.value,
      this.jobState.name: this.jobState.value,
      this.isOwnerCompleted.name: this.isOwnerCompleted.value,
      this.isFreelancerCompleted.name: this.isFreelancerCompleted.value,
      this.createdAt.name: FieldValue.serverTimestamp(),
    }).then((value) => createUserJob(uid: this.jobOwnerId.value));
  }

  Future<void> disposeCurrentFreelancerAndDeleteJob() async {
    addDisposeFeed(uid: this.jobOwnerId.value, type: "dispose");
    addDisposeFeed(uid: this.jobFreelancerId.value, type: "dispose");

    jobsRef.doc(this.jobId.value).update({
      "applications.$jobFreelancerId": false,
      this.jobFreelancerId.name: null,
      this.jobFreelancerName.name: null,
      this.jobFreelancerEmail.name: null,
      this.jobState.name: true,
      this.isOwnerCompleted.name: false,
      this.hasFreelancerUpdateRequest.name: false,
    }).then((value) {
      this.applications.value[this.jobFreelancerId.value] = false;
      this.jobFreelancerId.value = null;
      this.jobFreelancerName.value = null;
      this.jobFreelancerEmail.value = null;
      this.jobState.value = "open";
      this.isOwnerCompleted.value = false;
      this.hasFreelancerUpdateRequest.value = false;
    });
  }

  Future<void> addDisposeFeed({@required String uid, @required String type}) {
    return activityFeedRef.doc(uid).collection("feedItems").doc().set({
      "type": type,
      "this.jobId": this.jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "this.jobOwnerId": this.jobOwnerId,
      "jobFreelancerName": jobFreelancerName,
      "jobFreelancerId": jobFreelancerId,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> uploadTeamNotification(
      {@required String messageText, @required String type}) async {
    complaintRef.doc(currentUser.uid.value).set({
      "type": type,
      "messageText": messageText,
      "this.jobId": this.jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "this.jobOwnerId": this.jobOwnerId,
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
    @required double freelancerQualityRate,
    @required double freelancerAttitudeRate,
    @required double freelancerTimeManagementRate,
  }) async {
    AppUser user;
    await usersRef.doc(uid).get().then((doc) {
      user = AppUser.fromDocument(doc);
      double reviewsCount = user.reviews.value.length.toDouble();
      double jobsCount = user.jobs.value.length.toDouble();
      double newCompletedJobsCount = 0;
      user.jobs.value.values.forEach((job) {
        if (job['jobState'] == "jobCompleted") newCompletedJobsCount += 1.0;
      });
      double newCompletionRate = newCompletedJobsCount / jobsCount;
      double newQualityRateAverage = computeNewAverage(
          user.qualityRate.value, reviewsCount, freelancerQualityRate);
      double newAttitudeRateAverage = computeNewAverage(
          user.attitudeRate.value, reviewsCount, freelancerAttitudeRate);
      double newTimeManagementRateAverage = computeNewAverage(
          user.timeManagementRate.value,
          reviewsCount,
          freelancerTimeManagementRate);
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
        "job.$this.jobId": {
          "jobState": type,
        },
        "reviews.$this.jobId": {
          "type": type,
          "this.jobId": this.jobId,
          "jobTitle": jobTitle,
          "professionalTitle": professionalTitle,
          "jobOwnerName": jobOwnerName,
          "this.jobOwnerId": this.jobOwnerId,
          "freelancerReview": freelancerReview,
          "freelancerQualityRate": freelancerQualityRate,
          "freelancerAttitudeRate": freelancerAttitudeRate,
          "freelancerTimeManagementRate": freelancerTimeManagementRate,
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
