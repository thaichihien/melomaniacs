import 'package:flutter/material.dart';
import 'package:melomaniacs/views/home_screen.dart';

class Navigation {
  static final List<Widget> _navigationMap = [
    const HomeScreen(),
    const Center(child: Text("Search")),
    const Center(child: Text("Chat")),
    const Center(child: Text("Profile")),
  ];

  static Widget navigateTo(int page){
    return _navigationMap.elementAt(page); 
  }
}
