import 'package:flutter/material.dart';
import 'package:khadamat/widgets/custom_image.dart';
import 'package:khadamat/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: implement show full post to onTap function
      onTap: () => print('showing post'),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
