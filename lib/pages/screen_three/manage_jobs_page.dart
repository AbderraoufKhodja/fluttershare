import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/pages/screen_three/manage_job.dart';

class ManageJobsPage extends StatefulWidget {
  @override
  _JobsScreen createState() => _JobsScreen();
}

class _JobsScreen extends State<ManageJobsPage> with AutomaticKeepAliveClientMixin<ManageJobsPage> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildListJobs(),
    );
  }
}

buildListJobs() {
  List<JobContainer> jobContainers = [];
  currentUser.jobs.value.forEach((key, value) {
    jobContainers.add(JobContainer.fromDocument(value));
  });
  return ListView(
    physics: BouncingScrollPhysics(),
    children: jobContainers.isEmpty
        ? [
            Center(
              child: Text(kEmpty),
            )
          ]
        : jobContainers,
  );
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

  factory JobContainer.fromDocument(Map map) {
    return JobContainer(
      jobId: map['jobId'],
      jobOwnerId: map['jobOwnerId'],
      jobOwnerName: map['jobOwnerName'],
      jobFreelancerId: map['jobFreelancerId'],
      jobFreelancerName: map['jobFreelancerName'],
      professionalTitle: map['professionalTitle'],
      applications: map['applications'],
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
    return ManageJobsPage();
  }));
}
