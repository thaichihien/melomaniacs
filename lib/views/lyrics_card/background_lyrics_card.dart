import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../components/image_processer.dart';

class BackgroundLyricsCard extends StatelessWidget {
  final String backgroundImage;
  final Widget child;
  const BackgroundLyricsCard(
      {super.key, required this.child, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ImageProcessorProvider(backgroundImage), fit: BoxFit.cover)),
        child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width,
            height: 300,
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
            child: child));
  }
}
