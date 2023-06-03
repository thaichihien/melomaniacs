
import 'dart:convert';

List<Lyrics> lyricsFromJson(String str) => List<Lyrics>.from(json.decode(str).map((x) => Lyrics.fromJson(x)));

enum SelectedLyricsState {
  unselected,
  available,
  selected,
}

class Lyrics{
  final String content;
  SelectedLyricsState state;

  
  Lyrics({required this.content, this.state = SelectedLyricsState.unselected});

  factory Lyrics.fromJson(String json) => Lyrics(
        content: json,
    );

   
}
