import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';

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
  String location;
  String dateRange;
  String price;
  String newJobDescription;
  String newLocation;
  String newDateRange;
  String newPrice;
  String ownerReview;
  double ownerMannersRating;
  String freelancerReview;
  double freelancerJobQualityRating;
  double freelancerMannersRating;
  double freelancerTimeManagementRating;
  final Map applications;
  final Timestamp createdAt;
  Timestamp jobFreelancerEnrollmentDate;
  Timestamp ownerCompletedAt;
  Timestamp freelancerCompletedAt;
  bool isOwnerCompleted;
  bool isFreelancerCompleted;
  bool isVacant;
  bool hasFreelancerUpdateRequest;
  bool hasOwnerUpdateRequest;
  bool isRetrieved;

  Job(
      {this.jobId,
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
      this.ownerMannersRating,
      this.freelancerReview,
      this.freelancerJobQualityRating,
      this.freelancerMannersRating,
      this.freelancerTimeManagementRating,
      this.applications,
      this.isVacant,
      this.isOwnerCompleted,
      this.isFreelancerCompleted,
      this.hasFreelancerUpdateRequest,
      this.hasOwnerUpdateRequest,
      this.createdAt,
      this.ownerCompletedAt,
      this.freelancerCompletedAt,
      this.isRetrieved});

  factory Job.fromDocument(DocumentSnapshot doc) {
    return Job(
      jobId: doc["jobId"],
      jobOwnerId: doc["jobOwnerId"],
      jobOwnerName: doc["jobOwnerName"],
      jobOwnerEmail: doc["jobOwnerEmail"],
      jobFreelancerId: doc["jobFreelancerId"],
      jobFreelancerName: doc["jobFreelancerName"],
      jobFreelancerEmail: doc["jobFreelancerEmail"],
      jobFreelancerEnrollmentDate: doc["jobFreelancerEnrollmentDate"],
      isOwnerFreelancer: doc["isOwnerFreelancer"],
      jobTitle: doc["jobTitle"],
      jobPhotoUrl: doc["jobPhotoUrl"],
      professionalCategory: doc["professionalCategory"],
      professionalTitle: doc["professionalTitle"],
      jobDescription: doc["jobDescription"],
      location: doc["location"],
      dateRange: doc["dateRange"],
      price: doc["price"],
      newJobDescription: doc['newJobDescription'],
      newLocation: doc['newLocation'],
      newDateRange: doc['newDateRange'],
      newPrice: doc['newPrice'],
      ownerReview: doc['ownerReview'],
      ownerMannersRating: doc['ownerMannersRating'],
      freelancerReview: doc['freelancerReview'],
      freelancerJobQualityRating: doc['freelancerJobQualityRating'],
      freelancerMannersRating: doc['freelancerMannersRating'],
      freelancerTimeManagementRating: doc['timeManagementRating'],
      applications: doc["applications"],
      hasFreelancerUpdateRequest: doc["hasFreelancerUpdateRequest"],
      hasOwnerUpdateRequest: doc["hasOwnerUpdateRequest"],
      isVacant: doc["isVacant"],
      isOwnerCompleted: doc["isOwnerCompleted"],
      isFreelancerCompleted: doc["isFreelancerCompleted"],
      isRetrieved: doc["isRetrieved"],
      ownerCompletedAt: doc["ownerCompletedAt"],
      freelancerCompletedAt: doc["freelancerCompletedAt"],
      createdAt: doc["createdAt"],
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
  Future<void> deleteJob() async {
    final bool isJobOwner = currentUser.id == jobOwnerId;
    if (isJobOwner) {
      // delete job document form jobs collection
      jobsRef.document(jobId).get().then((doc) {
        if (doc.exists) doc.reference.delete();
      });

      // delete uploaded image for the ost
      storageRef.child("job_$jobId.jpg").delete();

      // then delete all messages
      messagesRef.document(jobId).get().then((doc) {
        if (doc.exists) doc.reference.delete();
      });
    }
  }

  handleApplyJob({
    @required String applicantId,
    @required String applicantName,
  }) {
    // TODO add isVacant sanity check
    bool _isApplied = applications.containsKey(applicantId) &&
        applications[applicantId] == null;
    if (_isApplied) {
      jobsRef
          .document(jobId)
          .updateData({'applications.$applicantId': FieldValue.delete()}).then(
              (value) => applications.remove(applicantId));
      removeApplyFromActivityFeed(
          applicantId: applicantId, applicantName: applicantName);
    } else if (!_isApplied) {
      jobsRef
          .document(jobId)
          .updateData({'applications.$applicantId': null}).then(
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
        id: jobOwnerId,
        type: "apply",
        applicantId: applicantId,
        applicantName: applicantName);
    addApplicationFeed(
        id: applicantId,
        type: "apply",
        applicantId: applicantId,
        applicantName: applicantName);
  }

  Future<void> removeApplyFromActivityFeed({
    @required String applicantId,
    @required String applicantName,
  }) async {
    activityFeedRef
        .document(jobOwnerId)
        .collection("feedItems")
        .where("jobId", isEqualTo: jobId)
        .where("type", isEqualTo: "apply")
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        snapshot.documents.forEach((doc) {
          doc.reference.delete();
        });
      }
    });
    activityFeedRef
        .document(applicantId)
        .collection("feedItems")
        .where("jobId", isEqualTo: jobId)
        .where("type", isEqualTo: "apply")
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        snapshot.documents.forEach((doc) {
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
          id: jobOwnerId,
          type: "acceptApplication",
          applicantId: applicantId,
          applicantName: applicantName);
      addApplicationFeed(
          id: applicantId,
          type: "acceptApplication",
          applicantId: applicantId,
          applicantName: applicantName);
      // Create a userJobs reference in firestore to store to point to
      // the message ids for the freelancer that can be used to list the messages.
      createUserJob(id: jobOwnerId);
      // Create a userJobs reference in firestore to store a reference to point to
      // the message ids for the job jobOwner that can be used to list the messages.
      createUserJob(id: jobFreelancerId);
      // create a chat reference on firestore
      openChat();
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
        id: jobOwnerId,
        type: "rejectApplication",
        applicantId: applicantId,
        applicantName: applicantName);
    addApplicationFeed(
        id: applicantId,
        type: "rejectApplication",
        applicantId: applicantId,
        applicantName: applicantName);
  }

  Future<void> addApplicationFeed(
      {@required String id,
      @required String type,
      @required String applicantId,
      @required String applicantName}) async {
    return await activityFeedRef
        .document(id)
        .collection("feedItems")
        .document()
        .setData({
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

  Future<void> updateJobApplicationStatue(
      {String applicantName = "",
      String applicantId = "",
      String applicantEmail = "",
      @required bool isAccept}) async {
    if (isAccept)
      jobsRef.document(jobId).updateData({
        'jobFreelancerId': applicantId,
        'jobFreelancerName': applicantName,
        'jobFreelancerEmail': applicantEmail,
        'jobFreelancerEnrollmentDate': FieldValue.serverTimestamp(),
        'applications.$applicantName': isAccept,
        'isVacant': !isAccept,
      }).then((_) {
        jobFreelancerId = applicantId;
        jobFreelancerName = applicantName;
        jobFreelancerEmail = applicantEmail;
        jobFreelancerEnrollmentDate = Timestamp.now();
        applications[applicantName] = isAccept;
        isVacant = !isAccept;
      });
    else
      jobsRef.document(jobId).updateData({
        'applications.$applicantName': isAccept,
        'isVacant': !isAccept,
      }).then((_) {
        applications[applicantName] = isAccept;
        isVacant = !isAccept;
      });
  }

  Future<void> createUserJob({@required id}) {
    return usersRef
        .document(id)
        .collection("userJobs")
        .document(jobId)
        .setData({
      "jobId": jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerId": jobOwnerId,
      "jobOwnerName": jobOwnerName,
      "isVacant": isVacant,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> openChat() async {
    return await messagesRef
        .document(jobId)
        .collection("messages")
        .document()
        .setData({"type": "open"});
  }

  Future<void> freelancerCompleteAndReviewJob({
    @required String ownerReview,
    @required double ownerMannersRating,
  }) async {
    addCompleteAndReviewFeed(id: jobOwnerId);
    addCompleteAndReviewFeed(id: jobFreelancerId);

    jobsRef.document(jobId).updateData({
      "ownerReview": ownerReview,
      "ownerMannersRating": ownerMannersRating,
      "isFreelancerCompleted": true,
      "freelancerCompletedAt": FieldValue.serverTimestamp(),
    }).then((value) {
      this.ownerReview = ownerReview;
      this.ownerMannersRating = ownerMannersRating;
      isFreelancerCompleted = true;
      freelancerCompletedAt = Timestamp.now();
    });
  }

  Future<void> ownerCompleteAndReviewJob({
    @required String freelancerReview,
    @required double freelancerJobQualityRating,
    @required double freelancerMannersRating,
    @required double freelancerTimeManagementRating,
  }) async {
    addCompleteAndReviewFeed(id: jobOwnerId);
    addCompleteAndReviewFeed(id: jobFreelancerId);

    jobsRef.document(jobId).updateData({
      "freelancerReview": freelancerReview,
      "freelancerJobQualityRating": freelancerJobQualityRating,
      "freelancerMannersRating": freelancerMannersRating,
      "freelancerTimeManagementRating": freelancerTimeManagementRating,
      "isOwnerCompleted": true,
      "ownerCompletedAt": FieldValue.serverTimestamp(),
    }).then((_) {
      this.freelancerReview = freelancerReview;
      this.freelancerJobQualityRating = freelancerJobQualityRating;
      this.freelancerMannersRating = freelancerMannersRating;
      this.freelancerTimeManagementRating = freelancerTimeManagementRating;
      this.isOwnerCompleted = true;
      this.ownerCompletedAt = Timestamp.now();
    });
  }

  Future<void> addCompleteAndReviewFeed({
    @required String id,
  }) async {
    activityFeedRef.document(id).collection("feedItems").document().setData({
      "type": "completeJob",
      "jobId": jobId,
      "jobTitle": jobTitle,
      "professionalTitle": professionalTitle,
      "jobOwnerName": jobOwnerName,
      "jobOwnerId": jobOwnerId,
      "jobFreelancerId": jobFreelancerId,
      "jobFreelancerName": jobFreelancerName,
      "freelancerReview": freelancerReview,
      "freelancerJobQualityRating": freelancerJobQualityRating,
      "freelancerMannersRating": freelancerMannersRating,
      "freelancerTimeManagementRating": freelancerTimeManagementRating,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addRequestUpdateTermsFeed(
      {@required String id,
      @required String type,
      @required String requestOwnerName,
      @required String requestOwnerId,
      @required String newPrice,
      @required String newLocation,
      @required String newDateRange,
      @required String newJobDescription}) {
    return activityFeedRef
        .document(id)
        .collection("feedItems")
        .document()
        .setData({
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
      "newLocation": newLocation,
      "newDateRange": newDateRange,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> addDecisionUpdateTermsFeed({
    @required String id,
    @required String type,
    @required String decisionOwnerName,
    @required String decisionOwnerId,
  }) {
    return activityFeedRef
        .document(id)
        .collection("feedItems")
        .document()
        .setData({
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
      "newLocation": newLocation,
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
      id: jobOwnerId,
      type: "acceptTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );
    addDecisionUpdateTermsFeed(
      id: jobFreelancerId,
      type: "acceptTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );

    jobsRef.document(jobId).updateData({
      "jobDescription": newJobDescription,
      "dateRange": newDateRange,
      "location": newLocation,
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
      id: jobOwnerId,
      type: "rejectTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );
    addDecisionUpdateTermsFeed(
      id: jobFreelancerId,
      type: "rejectTerms",
      decisionOwnerName: decisionOwnerName,
      decisionOwnerId: decisionOwnerId,
    );

    jobsRef.document(jobId).updateData({
      "newJobDescription": "",
      "newDateRange": "",
      "newLocation": "",
      "newPrice": "",
      "hasFreelancerUpdateRequest": false,
      "hasOwnerUpdateRequest": false,
    }).then((value) {
      newJobDescription = "";
      newDateRange = "";
      newLocation = "";
      newPrice = "";
      hasFreelancerUpdateRequest = false;
      hasOwnerUpdateRequest = false;
    });
  }

  Future<void> requestUpdateJobTermsFeed({
    @required String requestOwnerName,
    @required String requestOwnerId,
    @required String newJobDescription,
    @required String newPrice,
    @required String newLocation,
    @required String newDateRange,
  }) async {
    addRequestUpdateTermsFeed(
      id: jobOwnerId,
      type: "updateTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newJobDescription: newJobDescription,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );
    addRequestUpdateTermsFeed(
      id: jobFreelancerId,
      type: "updateTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newJobDescription: newJobDescription,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );

    final bool isJobFreelancer = jobFreelancerId == currentUser.id;
    final bool isJobOwner = jobOwnerId == currentUser.id;
    jobsRef.document(jobId).updateData({
      "newJobDescription": newJobDescription,
      "newPrice": newPrice,
      "newLocation": newLocation,
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

  Future<void> createJob() async {
    jobsRef.document(jobId).setData({
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
      "location": location,
      "dateRange": dateRange,
      "newJobDescription": newJobDescription,
      "newLocation": newLocation,
      "newPrice": newPrice,
      "newDateRange": newDateRange,
      "ownerReview": ownerReview,
      "freelancerReview": freelancerReview,
      "freelancerJobQualityRating": freelancerJobQualityRating,
      "mannersRating": freelancerMannersRating,
      "timeManagement": freelancerTimeManagementRating,
      "applications": applications,
      "hasFreelancerUpdateRequest": hasFreelancerUpdateRequest,
      "hasOwnerUpdateRequest": hasOwnerUpdateRequest,
      "isVacant": isVacant,
      "isOwnerCompleted": isOwnerCompleted,
      "isFreelancerCompleted": isFreelancerCompleted,
      "isRetrieved": isRetrieved,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> disposeCurrentFreelancerAndDeleteJob() async {
    addDisposeFeed(id: jobOwnerId, type: "dispose");
    addDisposeFeed(id: jobFreelancerId, type: "dispose");

    jobsRef.document(jobId).updateData({
      "applications.$jobFreelancerId": false,
      "jobFreelancerId": "",
      "jobFreelancerName": "",
      "jobFreelancerEmail": "",
      "isVacant": true,
      "isOwnerCompleted": false,
      "hasFreelancerUpdateRequest": false,
    }).then((value) {
      applications[jobFreelancerId] = false;
      jobFreelancerId = "";
      jobFreelancerName = "";
      jobFreelancerEmail = "";
      isVacant = true;
      isOwnerCompleted = false;
      hasFreelancerUpdateRequest = false;
    });
  }

  Future<void> addDisposeFeed({@required String id, @required String type}) {
    return activityFeedRef
        .document(id)
        .collection("feedItems")
        .document()
        .setData({
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

  void disposeCurrentFreelancerAndRepostJob() {
    print("disposeCurrentFreelancerAndRepostJob");
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
  static String ffnFreelancerJobQualityRating = "ffnFreelancerJobQualityRating";
  static String ffnMannersRating = "ffnMannersRating";
  static String ffnTimeManagement = "ffnTimeManagement";
  static String ffnApplications = "ffnApplications";
  static String ffnHasFreelancerUpdateRequest = "ffnHasFreelancerUpdateRequest";
  static String ffnHasOwnerUpdateRequest = "ffnHasOwnerUpdateRequest";
  static String ffnIsVacant = "ffnIsVacant";
  static String ffnIsOwnerCompleted = "ffnIsOwnerCompleted";
  static String ffnIsFreelancerCompleted = "ffnIsFreelancerCompleted";
  static String ffnIsRetrieved = "ffnIsRetrieved";
  static String ffnCreatedAt = "ffnCreatedAt";
}
