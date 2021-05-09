import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/job.dart';
import 'package:khadamat/pages/authentification_screen/create_freelance_account.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/screen_three/manage_job.dart';
import 'package:khadamat/widgets/custom_button.dart';
import 'package:khadamat/widgets/custom_image.dart';
import 'package:khadamat/widgets/custom_list_tile.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobCard extends StatefulWidget {
  final Job job;
  JobCard(this.job);

  @override
  _JobCardState createState() => _JobCardState(job: this.job);
}

class _JobCardState extends State<JobCard> {
  final Job job;
  int maxLines = 2;

  bool isShowDetail = false;

  _JobCardState({this.job});

  final String currentUserId = currentUser?.uid.value;
  bool isJobOwner;
  bool isLoading;
  bool isApplied;
  int applicationsCount;

  @override
  void initState() {
    super.initState();
    applicationsCount = job.getApplicationsCount();
    isJobOwner = currentUser.uid.value == job.jobOwnerId.value;
    isApplied = job.applications.value != null
        ? job.applications.value.containsKey(currentUserId)
            ? job.applications.value[currentUserId] == null
            : false
        : false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildJobHeader(),
            buildJobContent(),
            buildJobFooter(),
          ],
        ),
      ),
    );
  }

  buildJobHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(kBlankProfileUrl),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(
            job.jobOwnerName.value ?? "",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
              "${job.createdAt.value != null ? timeago.format(job.createdAt.value.toDate()) : "a moment ago"}"
              " | ${applicationsCount.toString()} applied"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: showDetails,
                icon: Icon(Icons.arrow_drop_down_circle),
              ),
              // isJobOwner
              //     ? Container()
              //     : isApplied
              //         ? Icon(Icons.bookmark)
              //         : Icon(Icons.bookmark_border),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 5.0, left: 5.0)),
      ],
    );
  }

  buildJobContent() {
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
                isShowDetail ? cachedNetworkImage(job.jobPhotoUrl.value) : Container(),
                CustomListTile(
                  description: job.jobTitle.value,
                  icon: Icon(
                    Icons.work,
                    color: Colors.blueGrey,
                  ),
                  maxLines: isShowDetail ? 10 : 2,
                ),
                CustomListTile(
                  description: job.professionalTitle.value,
                  icon: Icon(
                    Icons.work,
                    color: Colors.blueGrey,
                  ),
                  maxLines: isShowDetail ? 10 : 2,
                ),
                CustomListTile(
                  description: job.jobDescription.value,
                  icon: Icon(
                    Icons.description,
                    color: Colors.blueGrey,
                  ),
                  maxLines: isShowDetail ? 10 : 2,
                ),
                CustomListTile(
                  description: job.location.value.toString(),
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.blueGrey,
                  ),
                  maxLines: isShowDetail ? 10 : 2,
                ),
                CustomListTile(
                  description: job.dateRange.value,
                  icon: Icon(
                    Icons.schedule,
                    color: Colors.blueGrey,
                  ),
                  maxLines: isShowDetail ? 10 : 2,
                ),
              ],
            ),
          ),
          isShowDetail
              ? Container()
              : job.jobPhotoUrl.value.isEmpty
                  ? Container()
                  : Row(
                      children: [
                        VerticalDivider(
                          color: Colors.black,
                        ),
                        Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: cachedNetworkImage(job.jobPhotoUrl.value),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  buildJobFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isJobOwner
            ? Expanded(
                child: CustomButton(
                  text: kManage,
                  function: () => showManageJob(context, jobId: job.jobId.value),
                ),
              )
            : Expanded(
                child: CustomButton(
                  text: isApplied ? kUnapply : kApply,
                  function: () async {
                    if (!currentUser.isFreelancer.value) showCreateFreelanceProfile(context);
                    if (currentUser.isFreelancer.value) {
                      job.handleApplyJob(
                          applicantName: currentUser.username.value, applicantId: currentUserId);
                      setState(() {
                        applicationsCount += isApplied ? -1 : 1;
                        isApplied = !isApplied;
                      });
                    }
                  },
                ),
              ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 10.0),
            child: Text(
              "${job.price.value ?? ""} $kCurrency",
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

  // Note: To delete job, jobOwnerId and currentUserId must be equal, so they can be used interchangeably
  // handleDeleteJob(BuildContext parentContext) {
  //   return showDialog(
  //       context: parentContext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Text("Remove this job?"),
  //           children: <Widget>[
  //             SimpleDialogOption(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   if (job.).value
  //                   showDeleteJobScreen(context, job: job);
  //                 },
  //                 child: Text(
  //                   'Delete',
  //                   style: TextStyle(color: Colors.red),
  //                 )),
  //             SimpleDialogOption(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text('Cancel')),
  //           ],
  //         );
  //       });
  // }

  void showDetails() {
    setState(() {
      isShowDetail = !isShowDetail;
    });
  }

  showCreateFreelanceProfile(BuildContext parentContext) async {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(kHasNoFreelanceAccount),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateFreelanceAccount(appUser: currentUser)));
                  },
                  child: Text(
                    kCreateCard,
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(onPressed: () => Navigator.pop(context), child: Text(kCancel)),
            ],
          );
        });
  }
}

showJobCard(BuildContext context, {@required Job job}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return SafeArea(child: Scaffold(body: JobCard(job)));
  }));
}
