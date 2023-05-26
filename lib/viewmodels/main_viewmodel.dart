import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/account.dart';

class MainViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Account? _currentUser;
  Account get currentUser =>
      _currentUser ??
      Account(
          id: "",
          avatar: "",
          email: "",
          followers: [],
          following: [],
          username: "");

  Future<void> getUser() async {
    var snap =
        await _firestore.collection("users").doc(_auth.currentUser!.uid).get();
    _currentUser = Account.fromJson(snap.data() as Map<String, dynamic>);
    notifyListeners();
  }
}
