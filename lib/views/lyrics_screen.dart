import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:melomaniacs/components/button.dart';
import 'package:melomaniacs/components/image_processer.dart';
import 'package:melomaniacs/viewmodels/post_view_model.dart';
import 'package:melomaniacs/views/editor_screen.dart';
import 'package:melomaniacs/views/lyrics_item.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  @override
  void initState() {
    var postViewModel = Provider.of<PostViewModel>(context, listen: false);
    postViewModel.findSongLyricsFromSelected();
    postViewModel.resetSelectedLyrics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var postViewModel = Provider.of<PostViewModel>(context);
    return Container(
      decoration: BoxDecoration(
         
          image: DecorationImage(
              image: ImageProcessorProvider(postViewModel.selectedSong.image),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 80,
          title: Row(
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ImageProccessor(
                      src: postViewModel.selectedSong.image,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2, right: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        postViewModel.selectedSong.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        postViewModel.selectedSong.artist.join(", "),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            GlassmorphicContainer(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              borderRadius: 0,
              linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFffffff).withOpacity(0.1),
                    const Color(0xFFFFFFFF).withOpacity(0.05),
                  ],
                  stops: const [
                    0.1,
                    1,
                  ]),
              border: 0,
              blur: 10,
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFffffff).withOpacity(0.5),
                  const Color((0xFFFFFFFF)).withOpacity(0.5),
                ],
              ),
              child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        postViewModel.selectLyrics(index);
                      },
                      child: LyricsItem(
                        lyric: postViewModel.lyricsList[index],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 5);
                  },
                  itemCount: postViewModel.lyricsList.length),
            )
          ],
        ),
        floatingActionButton: postViewModel.lyricsLength > 0
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                child: LargeButton(
                    buttonText: "CREATE ${postViewModel.lyricsLength}/5",
                    onClick: () {
                      postViewModel.saveLyrics();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EditorScreen()));
                    }),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  // SelectedLyricsState setLyricsState(PostViewModel postViewModel,int index){
  //     if(index == postViewModel.startLyricsIndex || index == postViewModel.endLyricsIndex){
  //       return SelectedLyricsState.selected;
  //     }

  //     if((index == postViewModel.startLyricsIndex - 1) && (postViewModel.lyricsLength <= 6)){
  //       return SelectedLyricsState.available;
  //     }

  //     if((index == postViewModel.endLyricsIndex + 1) && (postViewModel.lyricsLength <= 6)){
  //       return SelectedLyricsState.available;
  //     }

  //     return SelectedLyricsState.unselected;
  // }
}
