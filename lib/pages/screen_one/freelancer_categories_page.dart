import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/pages/screen_one/freelancer_for_you_page.dart';
import 'package:khadamat/pages/home.dart';
import 'package:khadamat/widgets/progress.dart';

class FreelancerCategoriesPage extends StatefulWidget {
  @override
  _FreelancerCategoriesPage createState() => _FreelancerCategoriesPage();
}

class _FreelancerCategoriesPage extends State<FreelancerCategoriesPage>
    with AutomaticKeepAliveClientMixin<FreelancerCategoriesPage> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  Future<QuerySnapshot> searchResultsFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: categoriesList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          } else {
            return ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data.docs.map((doc) => categoryListTile(context, doc)).toList(),
            );
          }
        });
  }

  Widget categoryListTile(BuildContext context, QueryDocumentSnapshot doc) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              alignment: Alignment.centerRight,
              image:
                  CachedNetworkImageProvider(doc.data()['categoryBannerURL'] ?? kBlankCategoryUrl),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment(4, 0),
                colors: [Colors.white, Colors.transparent],
              ),
            ),
            child: ListTile(
              title: Text(doc.id),
              onTap: () => showFreelancerForYouPage(context, preferences: [doc.id]),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  Future<QuerySnapshot> categoriesList() => categoriesRef.get();
}
