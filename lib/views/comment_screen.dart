import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:melomaniacs/components/textfield.dart';
import 'package:melomaniacs/utils/colors.dart';
import 'package:melomaniacs/views/comment_item.dart';
import 'package:provider/provider.dart';

import '../models/comment.dart';
import '../utils/utils.dart';
import '../viewmodels/main_viewmodel.dart';
import '../viewmodels/post_view_model.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late final TextEditingController _commentController;
  late final PostViewModel _postViewModel;
  int amount = 0;
  bool enableSend = false;

  void sendComment(String userId, String username, String avatar) async {
    var (success, message) = await _postViewModel.commentPost(
        widget.postId, _commentController.text, userId, username, avatar);

    if (context.mounted) {
      if (success) {
        setState(() {
          _commentController.text = "";
        });
      }
      showSnakeBar(context, message);
    }
  }

  @override
  void initState() {
    _commentController = TextEditingController();
    _postViewModel = Provider.of<PostViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MainViewModel>(context).currentUser;
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('comments')
                .orderBy('date',descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Text(
                "Comments()",
                style: TextStyle(fontWeight: FontWeight.bold),
              );
              }

              return Text(
                "Comments(${snap.data!.docs.length})",
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            }),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder:
            (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

      
          return ListView.builder(
              itemCount: snap.data!.docs.length,
              itemBuilder: (context, index) => CommentItem(
                  content: Comment.fromJson(snap.data!.docs[index].data())));
        },
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Flexible(
                    child: CustomTextField(
                  textEditingController: _commentController,
                  hintText: "Write your comment..",
                  type: InputType.message,
                  onChanged: (text) {
                    if (text.isNotEmpty && !enableSend) {
                      setState(() {
                        enableSend = true;
                      });
                    } else if (text.isEmpty && enableSend) {
                      setState(() {
                        enableSend = false;
                      });
                    }
                  },
                )),
                const SizedBox(
                  width: 20,
                ),
                InkResponse(
                  onTap: () {
                    if (enableSend) {
                      sendComment(user.id, user.username, user.avatar);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: enableSend ? primaryColor : disablePrimaryColor),
                    child: _postViewModel.loading
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.black)))
                        : Icon(
                            Icons.send,
                            color: enableSend
                                ? Colors.black
                                : const Color.fromARGB(255, 72, 72, 72),
                            size: 30,
                          ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
