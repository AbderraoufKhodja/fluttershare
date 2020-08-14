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

class BusinessCard extends StatefulWidget {
  final String businessCardId;
  final String ownerId;
  final String username;
  final String jobCategory;
  final String address;
  final String description;
  final String mediaUrl;
  final dynamic likes;
  final String intro;
  final String bio;
  final String professionalExperience;
  final String training;
  final String diploma;
  final String licence;
  final String certification;
  final String experience;
  final String competences;
  final String achievement;
  final String recommendation;
  final String language;

  BusinessCard({
    this.businessCardId,
    this.ownerId,
    this.username,
    this.jobCategory,
    this.address,
    this.description,
    this.mediaUrl,
    this.likes,
    this.intro,
    this.bio,
    this.professionalExperience,
    this.training,
    this.diploma,
    this.licence,
    this.certification,
    this.experience,
    this.competences,
    this.achievement,
    this.recommendation,
    this.language,
  });

  factory BusinessCard.fromDocument(DocumentSnapshot doc) {
    return BusinessCard(
      businessCardId: doc['businessCardId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      jobCategory: doc['jobCategory'],
      address: doc['address'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
      intro: doc['intro'],
      bio: doc['bio'],
      professionalExperience: doc['professionalExperience'],
      training: doc['training'],
      diploma: doc['diploma'],
      licence: doc['licence'],
      certification: doc['certification'],
      experience: doc['experience'],
      competences: doc['competences'],
      achievement: doc['achievement'],
      recommendation: doc['recommendation'],
      language: doc['language'],
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
  _BusinessCardState createState() => _BusinessCardState(
        businessCardId: this.businessCardId,
        ownerId: this.ownerId,
        username: this.username,
        jobCategory: this.jobCategory,
        location: this.address,
        description: this.description,
        mediaUrl: this.mediaUrl,
        likes: this.likes,
        intro: this.intro,
        bio: this.bio,
        professionalExperience: this.professionalExperience,
        training: this.training,
        diploma: this.diploma,
        licence: this.licence,
        certification: this.certification,
        experience: this.experience,
        competences: this.competences,
        achievement: this.achievement,
        recommendation: this.recommendation,
        language: this.language,
        likeCount: getLikeCount(this.likes),
      );
}

class _BusinessCardState extends State<BusinessCard> {
  final String currentUserId = currentUser?.id;
  final String businessCardId;
  final String ownerId;
  final String username;
  final String jobCategory;
  final String location;
  final String description;
  final String mediaUrl;
  final String intro;
  final String bio;
  final String professionalExperience;
  final String training;
  final String diploma;
  final String licence;
  final String certification;
  final String experience;
  final String competences;
  final String achievement;
  final String recommendation;
  final String language;

  bool showHeart = false;
  bool isLiked;
  int likeCount;
  Map likes;

  _BusinessCardState({
    this.businessCardId,
    this.ownerId,
    this.username,
    this.jobCategory,
    this.intro,
    this.bio,
    this.professionalExperience,
    this.training,
    this.diploma,
    this.licence,
    this.certification,
    this.experience,
    this.competences,
    this.achievement,
    this.recommendation,
    this.language,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.likeCount,
  });

  handleDeleteBusinessCard(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this businessCard?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteBusinessCard();
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

  // Note: To delete businessCard, ownerId and currentUserId must be equal, so they can be used interchangeably
  deleteBusinessCard() async {
    // delete businessCard itself
    businessCardsRef
        .document(ownerId)
        .collection('userBusinessCards')
        .document(businessCardId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete uploaded image for the ost
    storageRef.child("businessCard_$businessCardId.jpg").delete();
    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .document(ownerId)
        .collection("feedItems")
        .where('businessCardId', isEqualTo: businessCardId)
        .getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // then delete all comments
    QuerySnapshot commentsSnapshot = await commentsRef
        .document(businessCardId)
        .collection('comments')
        .getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleLikeBusinessCard() {
    bool _isLiked = likes[currentUserId] == true;

    if (_isLiked) {
      businessCardsRef
          .document(ownerId)
          .collection('userBusinessCards')
          .document(businessCardId)
          .updateData({'likes.$currentUserId': false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      businessCardsRef
          .document(ownerId)
          .collection('userBusinessCards')
          .document(businessCardId)
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
    // add a notification to the businessCardOwner's activity feed only if comment made by OTHER user (to avoid getting notification for our own like)
    bool isNotBusinessCardOwner = currentUserId != ownerId;
    if (isNotBusinessCardOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(businessCardId)
          .setData({
        "type": "like",
        "userId": currentUser.id,
        "username": currentUser.username,
        "jobCategory": jobCategory,
        "userProfileImg": currentUser.photoUrl,
        "businessCardId": businessCardId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromActivityFeed() {
    bool isNotBusinessCardOwner = currentUserId != ownerId;
    if (isNotBusinessCardOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(businessCardId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  buildBusinessCardHeader() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        bool isBusinessCardOwner = currentUserId == ownerId;
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
              trailing: isBusinessCardOwner
                  ? IconButton(
                      onPressed: () => handleDeleteBusinessCard(context),
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

  buildBusinessCardImage() {
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

  buildBusinessCardFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 5.0)),
            GestureDetector(
              onTap: handleLikeBusinessCard,
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
                businessCardId: businessCardId,
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
          buildBusinessCardHeader(),
          buildBusinessCardImage(),
          buildBusinessCardFooter(),
        ],
      ),
    );
  }
}

showComments(BuildContext context,
    {String businessCardId, String ownerId, String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    //TODO: refactor showComment to support the BusinessCard class
    return Comments(
//      businessCardId: businessCardId,
//      businessCardOwnerId: ownerId,
//      businessCardMediaUrl: mediaUrl,
        );
  }));
}
