import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melomaniacs/models/api_status.dart';
import 'package:melomaniacs/models/post.dart';
import 'package:melomaniacs/models/comment.dart';
import 'package:melomaniacs/network/api_client.dart';
import 'package:uuid/uuid.dart';

import '../models/song.dart';
import '../utils/utils.dart';

class PostViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudStorage _storage = CloudStorage();
  late final ApiClient _api;
  String _error = "";
  List<Song> _songList = [];


  bool _loading = false;
  bool get loading => _loading;
  List<Song> get songList => _songList;
  String get error => _error;

  PostViewModel(){
    _api = ApiClient();
  }


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

  Future<bool> likePost(
      String postId, String userId, List<String> likes) async {
    try {
      if (likes.contains(userId)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([userId])
        });
        return false;
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([userId])
        });
        return true;
      }
    } catch (e) {
      debugPrint('like error : $e');
    }

    return false;
  }

  Future<(bool, String)> commentPost(String postId, String comment,
      String userId, String username, String avatar) async {
    String message = "";
    bool result = false;
    try {
      waiting();
      String commentId = const Uuid().v1();
      Comment newComment = Comment(
          id: commentId,
          userId: userId,
          postId: postId,
          username: username,
          date: DateTime.now(),
          avatar: avatar,
          comment: comment,
          likes: []);

      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(newComment.toJson());

      result = true;
      message = "Comment Successfully";
    } catch (e) {
      result = false;
      message = e.toString();
    }

    finish();
    return (result, message);
  }

  searchSong(String query) async {
    waiting();
    
    var response = await _api.getSongs(query);
    if(response is Success){
      debugPrint(response.data!.length.toString());
      _songList = response.data!;
    }else if(response is Failure){
      _error = response.errorMessage!;
      debugPrint(_error);
    }

    finish();
  }


}
