import 'package:flutter/material.dart';
import 'package:melomaniacs/components/button.dart';

import '../utils/colors.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SmallButton(buttonText: "POST", onClick: () {}))
        ],
      ),
      body: const SafeArea(
        minimum: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: primaryColor,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Name",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            TextField(
              decoration: InputDecoration(
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w100, color: primaryColor),
                  hintText: "Write your thoughts about music...",
                  border: InputBorder.none),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            )
          ]),
        ),
      ),
    );
  }
}
