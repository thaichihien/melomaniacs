import 'package:flutter/material.dart';
import 'package:melomaniacs/utils/colors.dart';
import 'package:melomaniacs/views/lyrics_card/background_lyrics_card.dart';
import 'package:melomaniacs/views/lyrics_card/genius_lyrics_card.dart';
import 'package:provider/provider.dart';

import '../viewmodels/post_view_model.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var postViewModel = Provider.of<PostViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Center(
        child: BackgroundLyricsCard(
            backgroundImage: postViewModel.selectedSong.image,
            child: GeniusLyricsCard(
                lyrics: postViewModel.savedLyricsList,
                song: postViewModel.selectedSong)),
      ),
      bottomNavigationBar: DefaultTabController(
        length: 2,
        child: SizedBox(
          height: 100,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity,
              color: greyColor,
              child: const TabBar(isScrollable: true, tabs: [
                Tab(icon: Icon(Icons.camera)),
                Tab(icon: Icon(Icons.edit)),
              ]),
            ),
            Container(
              color: Colors.white,
              height: 50,
              child: const TabBarView(children: [Text("camrera"), Text("edit")]),
            )
          ]),
        ),
      ),
    );
  }
}
