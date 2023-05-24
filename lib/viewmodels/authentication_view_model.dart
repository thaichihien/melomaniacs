import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melomaniacs/models/Account.dart';
import 'package:melomaniacs/utils/utils.dart';

class AuthViewModel extends ChangeNotifier {
  bool _loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get loading => _loading;

  waiting() {
    _loading = true;
    notifyListeners();
  }

  finish() {
    _loading = false;
    notifyListeners();
  }

  Future<(bool, String)> register(
      {required String email,
      required String password,
      required String username,
      Uint8List? image}) async {
    String message = "";
    bool result = false;
    try {
      waiting();

      var newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String photoUrl = image != null
          ? await Storage().uploadImage("avatars", image, false)
          : "";

      var savedUser = Account(
          id: newUser.user!.uid,
          avatar: photoUrl,
          email: email,
          followers: [],
          following: [],
          username: username);

      _firestore
          .collection('users')
          .doc(newUser.user!.uid)
          .set(savedUser.toJson());
      result = true;
      message = "You have successfully registered";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        result = false;
        message = "The password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        result = false;
        message = "The account already exists for that email";
      }
    } catch (e) {
      result = false;
      message = e.toString();
    }

    finish();
    return (result, message);
  }

  Future<(bool, String)> login(
      {required String email, required String password}) async {
    String message = "";
    bool result = false;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      result = true;
      message = "You have successfully registered";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        result = false;
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        result = false;
        message = 'Wrong password provided for that user';
      }
    } catch (e) {
      result = false;
      message = e.toString();
    }

    return (result, message);
  }
}
