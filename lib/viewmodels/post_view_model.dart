import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melomaniacs/models/post.dart';
import 'package:uuid/uuid.dart';

import '../utils/utils.dart';

class PostViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudStorage _storage = CloudStorage();

  bool _loading = false;
  bool get loading => _loading;

  waiting() {
    _loading = true;
    notifyListeners();
  }

  finish() {
    _loading = false;
    notifyListeners();
  }

  Future<(bool, String)> createPost({
    required String caption,
    List<Uint8List>? images,
    required String avatar,
    required String username,
  }) async {
    String message = "";
    bool result = false;
    try {
      waiting();
      // - Generate uuid
      var postId = const Uuid().v1();
      List<String> postImages = [];

      // - upload images (if not null or empty)
      if (images != null && images.isNotEmpty) {
        for (var img in images) {
          String photoUrl =
              await _storage.uploadImage("posts", img, postFolder: postId);
          postImages.add(photoUrl);
        }
      }

      var currentUser = _auth.currentUser!;
      // - Create Post model
      Post newPost = Post(
          id: postId,
          userId: currentUser.uid,
          caption: caption,
          username: username,
          date: DateTime.now(),
          avatar: avatar,
          images: postImages,
          likes: []);

      // - Save post to firebase
      _firestore.collection('posts').doc(postId).set(newPost.toJson());
      result = true;
      message = "Post Successfully";
    } catch (e) {
      result = false;
      message = e.toString();
    }

    finish();
    return (result, message);
  }

  Future<bool> likePost(String postId,String userId,List<String> likes) async{
    try {
      if(likes.contains(userId)){
        await _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayRemove([userId])
        });
        return false;
      }else{
        await _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayUnion([userId])
        });
        return true;
      }
    } catch (e) {
      debugPrint('like error : $e');
    }

    return false;
  }


}
