import 'package:flutter/material.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/pages/search.dart';
import 'package:khadamat/widgets/progress.dart';

class ItemsHorizontalView extends StatelessWidget {
  final Future futureItems;
  final String title;

  const ItemsHorizontalView(
      {Key key, @required this.title, @required this.futureItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        FutureBuilder(
          future: futureItems,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            List<FreelancerCard> freelancersList = [];
            try {
              snapshot.data.docs.forEach((doc) {
                AppUser user = AppUser.fromDocument(doc);
                FreelancerCard freelancer = FreelancerCard(user);
                freelancersList.add(freelancer);
              });
            } catch (e) {
              snapshot.data.forEach((doc) {
                AppUser user = AppUser.fromDocument(doc);
                FreelancerCard freelancer = FreelancerCard(user);
                freelancersList.add(freelancer);
              });
            }
            return Container(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: freelancersList,
              ),
            );
          },
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
