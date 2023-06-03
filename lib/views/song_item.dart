import 'package:flutter/material.dart';
import 'package:melomaniacs/components/image_processer.dart';
import 'package:melomaniacs/utils/colors.dart';

import '../models/song.dart';

class SongItem extends StatefulWidget {
  final Song song;
  const SongItem({super.key, required this.song});

  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: greyColor,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ImageProccessor(src: widget.song.image)),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, left: 8, right: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.song.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.song.artist.join(", "),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
