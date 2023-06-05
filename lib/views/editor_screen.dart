import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:melomaniacs/utils/colors.dart';
import 'package:melomaniacs/utils/utils.dart';
import 'package:melomaniacs/views/lyrics_card/background_lyrics_card.dart';
import 'package:melomaniacs/views/lyrics_card/genius_lyrics_card.dart';
import 'package:melomaniacs/views/post_screen.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../components/button.dart';
import '../viewmodels/post_view_model.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final ScreenshotController screenshotController;

  @override
  void initState() {
    screenshotController = ScreenshotController();
    super.initState();
  }

  Future<Uint8List?> saveImageToGallery(PostViewModel postViewModel) async {
    try {
      var image = await screenshotController.capture();
      postViewModel.saveImageToGallery(image!);
      return image;
    } on Exception catch (e) {
      showSnakeBar(context, e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var postViewModel = Provider.of<PostViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SmallButton(
                  buttonText: "SAVE",
                  onClick: () async {
                    var img = await saveImageToGallery(postViewModel);
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PostScreen(
                          createdLyricsCard: img,
                        ),
                      ));
                    }
                  }))
        ],
      ),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: BackgroundLyricsCard(
              backgroundImage: postViewModel.selectedSong.image,
              child: GeniusLyricsCard(
                  lyrics: postViewModel.savedLyricsList,
                  song: postViewModel.selectedSong)),
        ),
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
              child:
                  const TabBarView(children: [Text("camrera"), Text("edit")]),
            )
          ]),
        ),
      ),
    );
  }
}
