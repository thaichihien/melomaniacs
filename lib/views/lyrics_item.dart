import 'package:flutter/material.dart';
import 'package:melomaniacs/models/lyrics.dart';
import 'package:melomaniacs/utils/colors.dart';

class LyricsItem extends StatelessWidget {
  final Lyrics lyric;
  const LyricsItem({super.key, required this.lyric});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Text(lyric.content,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: lyric.state == SelectedLyricsState.selected
                    ? secondaryColor
                    : Colors.white,
                backgroundColor: _stateBackgroundColor())));
  }

  Color? _stateBackgroundColor() {
    switch (lyric.state) {
      case SelectedLyricsState.selected:
        return const Color.fromARGB(126, 255, 255, 0);
      case SelectedLyricsState.available:
        return const Color.fromARGB(66, 255, 255, 0);
      case SelectedLyricsState.unselected:
        return null;
      default:
        return null;
    }
  }
}
