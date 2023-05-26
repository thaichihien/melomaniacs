import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:melomaniacs/models/post.dart';
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
                  child: Image.network(user.avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: primaryColor,),
                  loadingBuilder: (context, child, loadingProgress) {
                    if(loadingProgress == null) {
                      return child;
                    } else {
                      return  Container(color: primaryColor,);
                    }
                  },)
                ))),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').orderBy('date',descending: true).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) => PostItem(
                      content: Post.fromJson(snap.data!.docs[index].data()),
                    ));
          },
        ),
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
