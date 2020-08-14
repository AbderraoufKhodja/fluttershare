import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/models/user.dart';
import 'package:khadamat/pages/activity_feed.dart';
import 'package:khadamat/pages/comments.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_image.dart';
import 'package:khadamat/widgets/progress.dart';

class JobPost extends StatefulWidget {
  final String jobPostId;
  final String jobCategory;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  JobPost({
    this.jobPostId,
    this.jobCategory,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
  });

  factory JobPost.fromDocument(DocumentSnapshot doc) {
    return JobPost(
      jobPostId: doc['jobPostId'],
      jobCategory: doc['jobCategory'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _JobPostState createState() => _JobPostState(
        jobPostId: this.jobPostId,
        jobCategory: this.jobCategory,
        ownerId: this.ownerId,
        username: this.username,
        location: this.location,
        description: this.description,
        mediaUrl: this.mediaUrl,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
      );
}

class _JobPostState extends State<JobPost> {
  final String currentUserId = currentUser?.id;
  final String jobCategory;
  final String jobPostId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  bool showHeart = false;
  bool isLiked;
  int likeCount;
  Map likes;

  _JobPostState({
    this.jobPostId,
    this.jobCategory,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.likeCount,
  });

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

  // Note: To delete jobPost, ownerId and currentUserId must be equal, so they can be used interchangeably
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

  handleLikeJobPost() {
    bool _isLiked = likes[currentUserId] == true;

    if (_isLiked) {
      jobPostsRef
          .document(ownerId)
          .collection('userJobPosts')
          .document(jobPostId)
          .updateData({'likes.$currentUserId': false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      jobPostsRef
          .document(ownerId)
          .collection('userJobPosts')
          .document(jobPostId)
          .updateData({'likes.$currentUserId': true});
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  addLikeToActivityFeed() {
    // add a notification to the jobPostOwner's activity feed only if comment made by OTHER user (to avoid getting notification for our own like)
    bool isNotJobPostOwner = currentUserId != ownerId;
    if (isNotJobPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(jobPostId)
          .setData({
        "type": "like",
        "username": currentUser.username,
        "jobCategory": jobCategory,
        "userId": currentUser.id,
        "userProfileImg": currentUser.photoUrl,
        "jobPostId": jobPostId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromActivityFeed() {
    bool isNotJobPostOwner = currentUserId != ownerId;
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

  buildJobPostHeader() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        bool isJobPostOwner = currentUserId == ownerId;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                backgroundColor: Colors.grey,
              ),
              title: GestureDetector(
                onTap: () => showProfile(context, profileId: user.id),
                child: Text(
                  user.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(location),
              trailing: isJobPostOwner
                  ? IconButton(
                      onPressed: () => handleDeleteJobPost(context),
                      icon: Icon(Icons.more_vert),
                    )
                  : Text(''),
            ),
            Container(
              child: Text(
                "$jobCategory",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "Description: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              description,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            Padding(padding: EdgeInsets.only(top: 5.0, left: 5.0)),
          ],
        );
      },
    );
  }

  buildJobPostImage() {
    return GridView.count(
      reverse: true,
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        cachedNetworkImage(mediaUrl),
      ],
    );
  }

  buildJobPostFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 5.0)),
            GestureDetector(
              onTap: handleLikeJobPost,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 5.0)),
            GestureDetector(
              onTap: () => showComments(
                context,
                jobPostId: jobPostId,
                ownerId: ownerId,
                mediaUrl: mediaUrl,
              ),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0),
          child: Text(
            "$likeCount likes",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);

    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: <Widget>[
          buildJobPostHeader(),
          buildJobPostImage(),
          buildJobPostFooter(),
        ],
      ),
    );
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
