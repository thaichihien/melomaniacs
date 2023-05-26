import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:melomaniacs/components/button.dart';
import 'package:melomaniacs/models/account.dart';
import 'package:melomaniacs/utils/colors.dart';
import 'package:melomaniacs/views/comment_screen.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../viewmodels/main_viewmodel.dart';
import '../viewmodels/post_view_model.dart';

class PostItem extends StatefulWidget {
  final Post content;
  const PostItem({super.key, required this.content});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  List<String> images = [];
  late final PostViewModel _postViewModel;
  late final Account user;
  bool liked = false;

  @override
  void initState() {
    super.initState();
    images = widget.content.images;
    user = Provider.of<MainViewModel>(context, listen: false).currentUser;
    _postViewModel = Provider.of<PostViewModel>(context, listen: false);
    liked = widget.content.likes.contains(user.id);
  }

  void likePost() async {
    bool isLike = await _postViewModel.likePost(
        widget.content.id, user.id, widget.content.likes);
    setState(() {
      liked = isLike;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: ClipOval(
                    child: Image.network(
                      widget.content.avatar,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Container(
                            color: primaryColor,
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.content.username,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.yMMMd().format(widget.content.date.toDate()),
                        style: const TextStyle(fontWeight: FontWeight.w100),
                      )
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            widget.content.caption.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Flexible(
                        child: Text(
                      widget.content.caption,
                      textAlign: TextAlign.left,
                    )))
                : const SizedBox(),
            SizedBox(
              height: images.isNotEmpty ? 5 : 0,
            ),
            images.isNotEmpty
                ? SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(8),
                      itemCount: images.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          images.elementAt(index),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Container(
                                width: 350,
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                LikeButton(
                  onClick: likePost,
                  liked: liked,
                  amount: widget.content.likes.length,
                ),
                const SizedBox(
                  width: 24,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.content.id)
                        .collection('comments')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const InkResponse(
                          splashColor: primaryColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        );
                      }

                      return InkResponse(
                        splashColor: primaryColor,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                    postId: widget.content.id,
                                  )));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              snap.data!.docs.length.toString(),
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      );
                    })
              ],
            )
          ]),
    );
  }
}
