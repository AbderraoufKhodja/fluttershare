import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:uuid/uuid.dart';

class Job {
  final String jobId;
  final String jobOwnerId;
  final String jobOwnerName;
  final String jobOwnerEmail;
  String jobFreelancerId;
  String jobFreelancerName;
  String jobFreelancerEmail;
  Timestamp jobFreelancerEnrollmentDate;
  final bool isOwnerFreelancer;
  final String jobTitle;
  final String professionalTitle;
  final String professionalCategory;
  final String jobDescription;
  final String location;
  final String dateRange;
  final String jobPhotoUrl;
  final String price;
  final Timestamp createdAt;
  final Map applications;
  bool isCompleted;
  bool isVacant;
  bool hasUpdateTermsRequest;
  bool isOnGoing;

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
    this.jobTitle,
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
    this.hasUpdateTermsRequest,
    this.createdAt,
  });

  factory Job.fromDocument(DocumentSnapshot doc) {
    return Job(
      jobId: doc["jobId"],
      jobOwnerId: doc["jobOwnerId"],
      jobOwnerName: doc["jobOwnerName"],
      jobOwnerEmail: doc["jobOwnerEmail"],
      jobFreelancerId: doc["jobOwnerId"],
      jobFreelancerName: doc["jobFreelancerName"],
      jobFreelancerEmail: doc["jobFreelancerEmail"],
      jobFreelancerEnrollmentDate: doc["jobFreelancerEnrollmentDate"],
      isOwnerFreelancer: doc["isOwnerFreelancer"],
      jobTitle: doc["jobTitle"],
      professionalCategory: doc["professionalCategory"],
      professionalTitle: doc["professionalTitle"],
      jobDescription: doc["jobDescription"],
      location: doc["location"],
      dateRange: doc["dateRange"],
      jobPhotoUrl: doc["jobPhotoUrl"],
      price: doc["price"],
      applications: doc["applications"],
      isVacant: doc["isVacant"],
      isOnGoing: doc["isOnGoing"],
      isCompleted: doc["isCompleted"],
      hasUpdateTermsRequest: doc["hasUpdateTermsRequest"],
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
      // delete job document form userJobs collection in usersRef
      usersRef
          .document(jobOwnerId)
          .collection("userJobs")
          .document(jobId)
          .get()
          .then((doc) {
        if (doc.exists) doc.reference.delete();
      });
      usersRef
          .document(jobFreelancerId)
          .collection("userJobs")
          .document(jobId)
          .get()
          .then((doc) {
        if (doc.exists) doc.reference.delete();
      });

      jobsRef.document(jobId).get().then((doc) {
        if (doc.exists) doc.reference.delete();
      });
      // delete uploaded image for the ost
      storageRef.child("job_$jobId.jpg").delete();
      // then delete all activity feed notifications
      activityFeedRef
          .document(jobOwnerId)
          .collection("feedItems")
          .where('jobId', isEqualTo: jobId)
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
      });
      activityFeedRef
          .document(jobFreelancerId)
          .collection("feedItems")
          .where('jobId', isEqualTo: jobId)
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
      });
      // then delete all messages
      messagesRef.document(jobId).get().then((doc) {
        if (doc.exists) doc.reference.delete();
      });
    }
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
    // add a notification to the jobOwner's activity feed only if message made
    // by OTHER user (to avoid getting notification for our own mark)
    addApplicationFeed(
        id: jobOwnerId,
        type: "apply",
        applicantId: currentUser.id,
        applicantName: currentUser.username);
    addApplicationFeed(
        id: currentUser.id,
        type: "apply",
        applicantId: currentUser.id,
        applicantName: currentUser.username);
  }

  Future<void> removeApplyFromActivityFeed() async {
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
        .document(currentUser.id)
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
    showManageJob(
      context,
      jobId: jobId,
      jobFreelancerId: null,
      jobFreelancerName: null,
      jobOwnerId: jobOwnerId,
    );
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
      "applications": applications,
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
        'isOnGoing': isAccept,
      }).then((_) {
        jobFreelancerId = applicantId;
        jobFreelancerName = applicantName;
        jobFreelancerEmail = applicantEmail;
        jobFreelancerEnrollmentDate = Timestamp.now();
        applications[applicantName] = isAccept;
        isOnGoing = isAccept;
      });
    else
      jobsRef.document(jobId).updateData({
        'applications.$applicantName': isAccept,
        'isOnGoing': isAccept,
      }).then((_) {
        applications[applicantName] = isAccept;
        isOnGoing = isAccept;
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
      "jobOwnerId": jobOwnerId,
      "jobOwnerName": jobOwnerName,
      "jobFreelancerId": jobFreelancerId,
      "jobFreelancerName": jobFreelancerName,
      "professionalTitle": professionalTitle,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
      "applications": applications,
    });
  }

  Future<void> openChat() async {
    return await messagesRef
        .document(jobId)
        .collection("messages")
        .document()
        .setData({"type": "open"});
  }

  Future<void> freelancerCompleteJob() async {
    // TODO handleCompleteJob
    print("handleApplicantCompleteJob");
  }

  Future<void> ownerCompleteJob() async {
    // TODO handleCompleteJob
    print("handleOwnerCompleteJob");
  }

  Future<void> freelancerDeleteJob() async {
    // TODO handleCompleteJob
    print("handleApplicantDeleteJob");
  }

  Future<void> ownerDeleteJob() async {
    // TODO handleCompleteJob
    print("handleOwnerDeleteJob");
  }

  Future<void> acceptUpdateJobTerms({
    @required String requestOwnerName,
    @required String requestOwnerId,
    @required String newPrice,
    @required String newLocation,
    @required String newDateRange,
  }) async {
    addTermsFeed(
      id: jobOwnerId,
      type: "acceptTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );
    addTermsFeed(
      id: jobFreelancerId,
      type: "acceptTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );
    jobsRef.document(jobId).updateData({
      "dateRange": newPrice,
      "location": newLocation,
      "price": newDateRange,
    });
  }

  Future<void> addTermsFeed(
      {@required String id,
      @required String type,
      @required String requestOwnerName,
      @required String requestOwnerId,
      @required String newPrice,
      @required String newLocation,
      @required String newDateRange}) {
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
      "newPrice": newPrice,
      "newLocation": newLocation,
      "newDateRange": newDateRange,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
      "applications": applications,
    });
  }

  Future<void> rejectUpdateJobTerms({
    @required String requestOwnerName,
    @required String requestOwnerId,
    @required String newPrice,
    @required String newLocation,
    @required String newDateRange,
  }) async {
    addTermsFeed(
      id: jobOwnerId,
      type: "rejectTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );
    addTermsFeed(
      id: jobFreelancerId,
      type: "rejectTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );
  }

  Future<void> requestUpdateJobTermsFeed({
    @required String requestOwnerName,
    @required String requestOwnerId,
    @required String newPrice,
    @required String newLocation,
    @required String newDateRange,
  }) async {
    addTermsFeed(
      id: jobOwnerId,
      type: "updateTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );
    addTermsFeed(
      id: jobFreelancerId,
      type: "updateTerms",
      requestOwnerName: requestOwnerName,
      requestOwnerId: requestOwnerId,
      newPrice: newPrice,
      newLocation: newLocation,
      newDateRange: newDateRange,
    );
  }

  Future<void> createJob({@required bool update}) async {
    update
        ? jobsRef.document(jobId).updateData({
            "jobId": jobId,
            "jobOwnerId": jobOwnerId,
            "jobOwnerName": jobOwnerName,
            "jobOwnerEmail": jobOwnerEmail,
            "jobFreelancerId": jobFreelancerId,
            "jobFreelancerName": jobFreelancerName,
            "jobFreelancerEmail": jobFreelancerEmail,
            "isOwnerFreelancer": isOwnerFreelancer,
            "jobTitle": jobTitle,
            "professionalCategory": professionalCategory,
            "professionalTitle": professionalTitle,
            "jobDescription": jobDescription,
            "location": location,
            "dateRange": dateRange,
            "jobPhotoUrl": jobPhotoUrl,
            "price": price,
            "applications": applications,
            "isVacant": isVacant,
            "isOnGoing": isOnGoing,
            "isCompleted": isCompleted,
            "hasUpdateTermsRequest": hasUpdateTermsRequest,
            "createdAt": FieldValue.serverTimestamp(),
          })
        : jobsRef.document(jobId).setData({
            "jobId": jobId,
            "jobOwnerId": jobOwnerId,
            "jobOwnerName": jobOwnerName,
            "jobOwnerEmail": jobOwnerEmail,
            "jobFreelancerId": jobFreelancerId,
            "jobFreelancerName": jobFreelancerName,
            "jobFreelancerEmail": jobFreelancerEmail,
            "isOwnerFreelancer": isOwnerFreelancer,
            "jobTitle": jobTitle,
            "professionalCategory": professionalCategory,
            "professionalTitle": professionalTitle,
            "jobDescription": jobDescription,
            "location": location,
            "dateRange": dateRange,
            "jobPhotoUrl": jobPhotoUrl,
            "price": price,
            "applications": applications,
            "isVacant": isVacant,
            "isOnGoing": isOnGoing,
            "isCompleted": isCompleted,
            "hasUpdateTermsRequest": hasUpdateTermsRequest,
            "createdAt": FieldValue.serverTimestamp(),
          });
  }

  Future<void> disposeCurrentFreelancerAndDeleteJob() async {
    addDisposeFeed(id: jobOwnerId, type: "dispose");
    addDisposeFeed(id: jobFreelancerId, type: "dispose");
    applications[jobFreelancerId] = false;
    jobFreelancerId = "";
    jobFreelancerName = "";
    jobFreelancerEmail = "";
    isVacant = true;
    isOnGoing = false;
    isCompleted = false;
    hasUpdateTermsRequest = false;
    createJob(update: true);
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
      "applications": applications,
    });
  }

  void disposeCurrentFreelancerAndRepostJob() {
    print("disposeCurrentFreelancerAndRepostJob");
  }
}
