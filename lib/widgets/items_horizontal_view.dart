import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/widgets/freelancer_card.dart';
import 'package:shimmer/shimmer.dart';

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
        FutureBuilder<dynamic>(
          future: futureItems,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                width: 280.0,
                height: 180.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[350],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );
              ;
            }
            List<FreelancerCard> freelancersList = [];
            if (snapshot.data is QuerySnapshot) {
              snapshot.data.docs.forEach((doc) {
                AppUser user = AppUser.fromDocument(doc);
                FreelancerCard freelancer = FreelancerCard(user);
                freelancersList.add(freelancer);
              });
            } else if (snapshot.data is List<DocumentSnapshot>) {
              snapshot.data.forEach((doc) {
                AppUser user = AppUser.fromDocument(doc);
                FreelancerCard freelancer = FreelancerCard(user);
                freelancersList.add(freelancer);
              });
            }
            return Container(
              height: 180,
              child: ListView(
                physics: BouncingScrollPhysics(),
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
