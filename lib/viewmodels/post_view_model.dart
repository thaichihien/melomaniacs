import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melomaniacs/models/api_status.dart';
import 'package:melomaniacs/models/lyrics.dart';
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
  Song? _selectedSong;
  List<int> _selectedLyricsIndex = [-1, -1];
  List<Lyrics> _lyricsList = [];

  bool _loading = false;
  bool get loading => _loading;
  List<Song> get songList => _songList;
  String get error => _error;
  List<Lyrics> get lyricsList => _lyricsList;
  Song get selectedSong => _selectedSong!;
  int get lyricsLength {
    if (_selectedLyricsIndex[0] == -1 || _selectedLyricsIndex[1] == -1)
      return 0;
    var length = _selectedLyricsIndex[1] - _selectedLyricsIndex[0] + 1;
    return length < 0 ? 0 : length;
  }

  int get startLyricsIndex => _selectedLyricsIndex[0];
  int get endLyricsIndex => _selectedLyricsIndex[1];

  PostViewModel() {
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

  void searchSong(String query) async {
    waiting();

    var response = await _api.getSongs(query);
    if (response is Success) {
      debugPrint(response.data!.length.toString());
      _songList = response.data!;
    } else if (response is Failure) {
      _error = response.errorMessage!;
      debugPrint(_error);
    }

    finish();
  }

  void selectSong(Song newSelectedSong) {
    _selectedSong = newSelectedSong;
  }

  void findSongLyrics(String link) async {
    waiting();

    var response = await _api.getLyrics(link);
    if (response is Success) {
      _lyricsList = response.data!;
    } else if (response is Failure) {
      _error = response.errorMessage!;
      debugPrint(_error);
    }

    finish();
  }

  void findSongLyricsFromSelected() async {
    _lyricsList = [];
    findSongLyrics(selectedSong.link);
  }

  void selectLyrics(int index) {
    var lyricsAtIndex = lyricsList[index];

    debugPrint("$index : ${lyricsAtIndex.state}");

    if (lyricsAtIndex.state != SelectedLyricsState.selected &&
        lyricsLength >= 6) {
      debugPrint("$lyricsLength");
      return;
    }

    debugPrint(
        "$index : ${lyricsAtIndex.state == SelectedLyricsState.unselected}");

    if (lyricsAtIndex.state == SelectedLyricsState.unselected) {
      clearAllSelectedLyrics(clearSaved: true);
      _selectedLyricsIndex[0] = index;
      _selectedLyricsIndex[1] = index;
      lyricsAtIndex.state = SelectedLyricsState.selected;
      debugPrint("after : $index : ${lyricsAtIndex.state}");
      setAvailableLyricsState(index - 1);
      setAvailableLyricsState(index + 1);
    } else if (lyricsAtIndex.state == SelectedLyricsState.available) {
      if (index < startLyricsIndex) {
        lyricsAtIndex.state = SelectedLyricsState.selected;
        _selectedLyricsIndex[0] = index;
        setAvailableLyricsState(index - 1);
      } else if (index > endLyricsIndex) {
        lyricsAtIndex.state = SelectedLyricsState.selected;
        _selectedLyricsIndex[1] = index;
        setAvailableLyricsState(index + 1);

       

      }

        if(lyricsLength >= 6){
          removeAllAvailable();
        }

    } else if (lyricsAtIndex.state == SelectedLyricsState.selected) {
      if (index == startLyricsIndex) {
        if (lyricsLength == 1) {
          clearAllSelectedLyrics();
        } else {
          _selectedLyricsIndex[0] = index + 1;
          lyricsList[index - 1].state = SelectedLyricsState.unselected;
          setAvailableLyricsState(index, clearIndex: index - 1);

          if(lyricsLength == 5){
            setAvailableLyricsState(endLyricsIndex + 1);
          }


        }
      } else {
        clearAllSelectedLyrics(from: index, to: endLyricsIndex + 1);
        _selectedLyricsIndex[1] = index - 1;
        setAvailableLyricsState(index);

        if(lyricsLength == 5){
            setAvailableLyricsState(startLyricsIndex - 1);
          }
      }




    }

    notifyListeners();
  }

  void clearAllSelectedLyrics({int? from, int? to, bool clearSaved = false}) {
    var fromIndex = from ?? startLyricsIndex - 1;
    var toIndex = to ?? endLyricsIndex + 1;

    if (fromIndex < 0 || toIndex < 0) {
      return;
    }

    for (var i = fromIndex; i <= toIndex; i++) {
      lyricsList[i].state = SelectedLyricsState.unselected;
    }

    if (clearSaved) {
      resetSelectedLyrics();
    }
  }

  void resetSelectedLyrics() {
    _selectedLyricsIndex[0] = -1;
    _selectedLyricsIndex[1] = -1;
  }

  void setAvailableLyricsState(int index, {int? clearIndex}) {
    // - check length
    if (lyricsLength >= 6 || index < 0 || index >= lyricsList.length) {
      return;
    }

    if (clearIndex != null) {
      if (clearIndex >= 0 && clearIndex < lyricsList.length) {
        lyricsList[index].state = SelectedLyricsState.unselected;
      }
    }

    lyricsList[index].state = SelectedLyricsState.available;
  }

  void removeAllAvailable(){
    if(startLyricsIndex > 0){
      lyricsList[startLyricsIndex - 1].state = SelectedLyricsState.unselected;
    }

    if(endLyricsIndex < lyricsList.length - 1){
      lyricsList[endLyricsIndex + 1].state = SelectedLyricsState.unselected;
    }
  }

}
