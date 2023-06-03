import 'package:flutter/material.dart';

import '../utils/colors.dart';

Image _imageMainProcessing(String src) {
  return Image.network(
    src,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) => Container(
      color: primaryColor,
    ),
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return Container(
          color: primaryColor,
        );
      }
    },
  );
}

ImageProvider<Object> ImageProcessorProvider(String src){
  return _imageMainProcessing(src).image;
}

class ImageProccessor extends StatelessWidget {
  final String src;

  const ImageProccessor({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    return _imageMainProcessing(src);
  }
}



