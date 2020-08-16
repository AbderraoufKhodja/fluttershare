import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/pages/comments.dart';
import 'package:khadamat/pages/home.dart';

class Job {
  final String jobPostId;
  final String jobCategory;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final String price;
  final String schedule;
  final Timestamp timestamp;
  final bool isCompleted;
  final bool isVacant;
  final bool isOnGoing;
  final dynamic marks;
  final dynamic worker;
  final bool hasAccepted;

  Job({
    this.jobPostId,
    this.jobCategory,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.marks,
    this.price,
    this.schedule,
    this.timestamp,
    this.isVacant,
    this.isOnGoing,
    this.isCompleted,
    this.worker,
    this.hasAccepted,
  });

  factory Job.fromDocument(DocumentSnapshot doc) {
    return Job(
      jobPostId: doc['jobPostId'],
      jobCategory: doc['jobCategory'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      marks: doc['marks'],
      price: doc['price'],
      schedule: doc['schedule'],
      timestamp: doc['timestamp'],
      isVacant: doc['isVacant'],
      isOnGoing: doc['isOnGoing'],
      isCompleted: doc['isCompleted'],
      worker: doc["worker"],
      hasAccepted: doc["hasAccepted"],
    );
  }

  handleDeleteJobPost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this jobPost?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteJobPost();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  // Note: To delete jobPost, ownerId and currentUser.id must be equal, so they can be used interchangeably
  deleteJobPost() async {
    // delete jobPost itself
    jobPostsRef
        .document(ownerId)
        .collection('userJobPosts')
        .document(jobPostId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete uploaded image for the ost
    storageRef.child("jobPost_$jobPostId.jpg").delete();
    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .document(ownerId)
        .collection("feedItems")
        .where('jobPostId', isEqualTo: jobPostId)
        .getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // then delete all comments
    QuerySnapshot commentsSnapshot = await commentsRef
        .document(jobPostId)
        .collection('comments')
        .getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleMarkJobPost() {
    bool _isMarked = marks[currentUser.id] == true;
    if (_isMarked) {
      jobPostsRef
          .document(ownerId)
          .collection('userJobPosts')
          .document(jobPostId)
          .updateData({'marks.$currentUser.id': false});
      removeMarkFromActivityFeed();
    } else if (!_isMarked) {
      jobPostsRef
          .document(ownerId)
          .collection('userJobPosts')
          .document(jobPostId)
          .updateData({'marks.$currentUser.id': true});
      addMarkToActivityFeed();
    }
  }

  addMarkToActivityFeed() {
    // add a notification to the jobPostOwner's activity feed only if comment made by OTHER user (to avoid getting notification for our own mark)
    bool isNotJobPostOwner = currentUser.id != ownerId;
    if (isNotJobPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(jobPostId)
          .setData({
        "type": "mark",
        "username": currentUser.username,
        "jobCategory": jobCategory,
        "userId": currentUser.id,
        "userProfileImg": currentUser.photoUrl,
        "jobPostId": jobPostId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
        "isVacant": isVacant,
        "isOnGoing": isOnGoing,
        "isCompleted": isCompleted,
        "worker": worker,
        "hasAccepted": hasAccepted,
      });
    }
  }

  removeMarkFromActivityFeed() {
    bool isNotJobPostOwner = currentUser.id != ownerId;
    if (isNotJobPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(jobPostId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }
}

showComments(BuildContext context,
    {String jobPostId, String ownerId, String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    //TODO: refactor showComment to support the JobPost class
    return Comments(
//      jobPostId: jobPostId,
//      jobPostOwnerId: ownerId,
//      jobPostMediaUrl: mediaUrl,
        );
  }));
}
