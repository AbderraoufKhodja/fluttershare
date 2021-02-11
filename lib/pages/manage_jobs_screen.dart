import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/manage_job.dart';
import 'package:khadamat/widgets/progress.dart';

class ManageJobsScreen extends StatefulWidget {
  @override
  _JobsScreen createState() => _JobsScreen();
}

class _JobsScreen extends State<ManageJobsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildListJobs(),
    );
  }
}

buildListJobs() {
  return FutureBuilder<QuerySnapshot>(
      future: usersRef
          .doc(currentUser.uid)
          .collection('userJobs')
          .orderBy("createdAt", descending: false)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<JobContainer> job = [];
        snapshot.data.docs.forEach((doc) {
          job.add(JobContainer.fromDocument(doc));
        });
        return ListView(
          children: job,
        );
      });
}

class JobContainer extends StatelessWidget {
  final String jobId;
  final String jobOwnerId;
  final String jobOwnerName;
  final String jobFreelancerId;
  final String jobFreelancerName;
  final String professionalTitle;
  final Map applications;

  JobContainer({
    this.jobId,
    this.jobOwnerId,
    this.jobOwnerName,
    this.jobFreelancerId,
    this.jobFreelancerName,
    this.professionalTitle,
    this.applications,
  });

  factory JobContainer.fromDocument(DocumentSnapshot doc) {
    return JobContainer(
      jobId: doc['jobId'],
      jobOwnerId: doc['jobOwnerId'],
      jobOwnerName: doc['jobOwnerName'],
      jobFreelancerId: doc['jobFreelancerId'],
      jobFreelancerName: doc['jobFreelancerName'],
      professionalTitle: doc['professionalTitle'],
      applications: doc['applications'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => showManageJob(context, jobId: jobId),
          child: ListTile(
            title: Text(professionalTitle),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(kBlankProfileUrl),
            ),
            subtitle: Text("job owner: $jobOwnerName"),
          ),
        ),
        Divider(),
      ],
    );
  }
}

showManageJobsScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ManageJobsScreen();
  }));
}
