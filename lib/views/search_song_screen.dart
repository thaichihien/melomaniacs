import 'package:flutter/material.dart';
import 'package:melomaniacs/components/button.dart';
import 'package:melomaniacs/components/textfield.dart';
import 'package:melomaniacs/utils/colors.dart';
import 'package:melomaniacs/views/lyrics_screen.dart';
import 'package:melomaniacs/views/song_item.dart';
import 'package:provider/provider.dart';

import '../viewmodels/post_view_model.dart';

class SearchSongScreen extends StatefulWidget {
  const SearchSongScreen({super.key});

  @override
  State<SearchSongScreen> createState() => _SearchSongScreenState();
}

class _SearchSongScreenState extends State<SearchSongScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var postViewModel = Provider.of<PostViewModel>(context);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: primaryColor,
          floating: true,
          pinned: true,
          snap: false,
          centerTitle: false,
          actions: [
            SmallButton(
              buttonText: "SELECT",
              onClick: () {},
              color: secondaryColor,
            )
          ],
          bottom: AppBar(
              backgroundColor: primaryColor,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 45,
                  child: CustomTextField(
                    textEditingController: _searchController,
                    hintText: "Search for song title,artist,...",
                    type: InputType.search,
                    onFieldSubmitted: (value) {
                      debugPrint(value);
                      searchSong(postViewModel, value);
                    },
                  ),
                ),
              )),
        ),
        SliverList(
          delegate: postViewModel.loading
              ? SliverChildListDelegate.fixed([
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewPadding.top,
                    child: const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  )
                ])
              : SliverChildBuilderDelegate((context, index) {
                  return InkWell(
                      onTap: () {
                        postViewModel.selectSong(postViewModel.songList[index]);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LyricsScreen()));
                      },
                      child: SongItem(song: postViewModel.songList[index]));
                }, childCount: postViewModel.songList.length),
        ),
      ],
    ));
  }

  void searchSong(PostViewModel postViewModel, String value) {
    postViewModel.searchSong(value);
  }
}
