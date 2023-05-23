import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();

  var file = await picker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }

  return null;
}

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(String folder, Uint8List file, bool isPost) async {
    var dic = _storage.ref().child(folder).child(_auth.currentUser!.uid);
    //var task = dic.putData(file);
    var snap = await dic.putData(file);
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}

void showSnakeBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    content,
    style: const TextStyle(color: Colors.white),
  )));
}
