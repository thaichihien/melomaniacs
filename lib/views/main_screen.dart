import 'package:flutter/material.dart';
import 'package:melomaniacs/utils/colors.dart';
import 'package:melomaniacs/viewmodels/main_viewmodel.dart';
import 'package:melomaniacs/views/navigation_pages.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;

  @override
  void initState()  {
    initData();
    super.initState();
  }

  initData() async {
    await Provider.of<MainViewModel>(context,listen: false).getUser();
  }

  void changePage(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigation.navigateTo(_page),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.message),label: "Message"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
        ],
        currentIndex: _page,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black,
        onTap: changePage,
        showSelectedLabels: false,
        iconSize: 30,
      ),
      
    );
  }
}
