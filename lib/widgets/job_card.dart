import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/activity_feed.dart';
import 'package:khadamat/pages/comments.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_image.dart';
import 'package:khadamat/widgets/custom_list_tile.dart';
import 'package:khadamat/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobCard extends StatefulWidget {
  final Job job;
  JobCard(this.job);

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  final String currentUserId = currentUser?.id;
  bool isLoading;
  bool isMarked;
  Map marks;

  @override
  Widget build(BuildContext context) {
    isMarked = (widget.job.marks[currentUserId] == true);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildJobPostHeader(),
          buildJobPostImage(),
          buildJobPostFooter(),
        ],
      ),
    );
  }

  // Note: To delete jobPost, ownerId and currentUserId must be equal, so they can be used interchangeably
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
                    widget.job.deleteJobPost();
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

  handleMarkJobPost(Map marks) {
    bool _isMarked = marks[currentUserId] == true;
    if (_isMarked) {
      setState(() {
        isMarked = false;
        marks[currentUserId] = false;
      });
    } else if (!_isMarked) {
      setState(() {
        isMarked = true;
        marks[currentUserId] = true;
      });
    }
  }

  buildJobPostHeader() {
    bool isJobPostOwner = currentUserId == widget.job.ownerId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(widget.job.mediaUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: widget.job.ownerId),
            child: Text(
              widget.job.username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(timeago.format(widget.job.timestamp.toDate())),
          trailing: isJobPostOwner
              ? IconButton(
                  onPressed: () => widget.job.handleDeleteJobPost(context),
                  icon: Icon(Icons.more_vert),
                )
              : IconButton(
                  onPressed: () => print("job marked (saved)"),
                  icon: isMarked
                      ? Icon(Icons.bookmark_border)
                      : Icon(Icons.bookmark),
                ),
        ),
        Padding(padding: EdgeInsets.only(top: 5.0, left: 5.0)),
      ],
    );
  }

  buildJobPostImage() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomListTile(
                  description: widget.job.jobCategory,
                  icon: Icon(
                    Icons.work,
                    color: Colors.blueGrey,
                  ),
                ),
                CustomListTile(
                  description: widget.job.description,
                  icon: Icon(
                    Icons.description,
                    color: Colors.blueGrey,
                  ),
                ),
                CustomListTile(
                  description: widget.job.location,
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.blueGrey,
                  ),
                ),
                CustomListTile(
                  description: widget.job.schedule,
                  icon: Icon(
                    Icons.schedule,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.black,
          ),
          widget.job.mediaUrl.isEmpty
              ? Text("")
              : Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: cachedNetworkImage(widget.job.mediaUrl),
                ),
        ],
      ),
    );
  }

  buildJobPostFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomButton(
            text: "Message",
            function: () => print("Message"),
          ),
        ),
        Expanded(
          child: CustomButton(
            text: "Apply",
            function: () => print("Apply"),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 10.0),
            child: Text(
              "${widget.job.price} DA",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
