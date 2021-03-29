import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:khadamat/constants.dart';
import 'package:khadamat/models/app_user.dart';
import 'package:khadamat/pages/profile.dart';

class FreelancerCard extends StatelessWidget {
  final AppUser user;

  FreelancerCard(this.user);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showProfile(
        context,
        profileId: user.uid.value,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                    image: CachedNetworkImageProvider(user.photoURL.value ?? kBlankProfileUrl),
                  ),
                ),
              ),
              Container(
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.white, Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(user.globalRate.value?.toString() ?? kMissingData),
                            Icon(
                              Icons.star,
                              color: Colors.amber[600],
                              size: 15,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              user.username.value ?? kMissingData,
                              style: TextStyle(
                                fontFamily: "ReemKufi-Regular",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 3),
                              color: Colors.black,
                              width: 100,
                              height: 1,
                            ),
                            Text(
                              user.professionalTitle.value?.toUpperCase() ?? kMissingData,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
