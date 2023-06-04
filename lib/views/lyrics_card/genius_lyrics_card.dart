import 'package:flutter/material.dart';
import 'package:melomaniacs/models/song.dart';

class GeniusLyricsCard extends StatelessWidget {
  final List<String> lyrics;
  final Song song;

  const GeniusLyricsCard({super.key, required this.lyrics, required this.song});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
           top: 25,
          left: 0,
          child: Text('"',style: TextStyle(
          fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white
        ),)),
        Positioned(
          top: 45,
          left: 10,
          right: 0,
          bottom: 0,
          child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Container(
                  
                  child: Text(
                    lyrics[index],
                    style: const TextStyle(
                      backgroundColor: Colors.white,
                      fontSize: 18
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 5);
              },
              itemCount: lyrics.length),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              songCredit(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),
            ),
          ),
        )
      ],
    );
  }

  String songCredit() {
    var artist = song.artist.join(", ").toUpperCase();
    var title = ' "${song.title.toUpperCase()}"';
    return artist + title;
  }
}
