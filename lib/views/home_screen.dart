import 'package:flutter/material.dart';
import 'package:melomaniacs/viewmodels/main_viewmodel.dart';
import 'package:melomaniacs/views/post_item.dart';
import 'package:melomaniacs/views/post_screen.dart';
import 'package:provider/provider.dart';

import '../components/gradient_text.dart';
import '../models/account.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Account user = Provider.of<MainViewModel>(context).currentUser;

    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
            centerTitle: true,
            title: const GradientText(
              "Melodimaniacs",
              gradient: specialColorVertial,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  fontFamily: 'Dancing Script'),
            ),
            leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipOval(
                  child: Image(
                    image: NetworkImage(user.avatar),
                    fit: BoxFit.cover,
                  ),
                ))),
        body: const PostItem(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PostScreen(),
            ));
          },
          shape: const CircleBorder(),
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, gradient: specialColorDiagonal),
              child: const Icon(
                Icons.add,
                size: 40,
              )),
        ));
  }
}