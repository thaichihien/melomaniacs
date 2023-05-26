import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:melomaniacs/utils/colors.dart';

import '../models/comment.dart';

class CommentItem extends StatefulWidget {
  final Comment content;
  const CommentItem({super.key, required this.content});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.content.avatar),
              radius: 25,
            ),
            const SizedBox(
              width: 16,
            ),
            SizedBox(
              width: 270,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          widget.content.username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd()
                            .add_Hm()
                            .format(widget.content.date.toDate()),
                        style: const TextStyle(color: primaryColor),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(child: Text(widget.content.comment))
                ],
              ),
            )
          ]),
          const SizedBox(
            height: 8,
          ),
          const Divider(
            color: primaryColor,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    size: 30,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
