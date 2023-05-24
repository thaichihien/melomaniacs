import 'package:flutter/material.dart';
import 'package:melomaniacs/components/button.dart';

import '../utils/colors.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child:  Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: primaryColor,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.w100),
                  )
                ],
              ),
            ),
            IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Flexible(
            child: Text(
                "Say I love you, girl, but I'm out of timeSay I'm there for you, but I'm out of time 🎵")),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            LikeButton(liked: true,amount: 0,)
          ],
        )
      ]),
    );
  }
}
