import 'package:flutter/material.dart';
import 'package:melomaniacs/utils/colors.dart';

class NavigateGuide extends StatelessWidget {
  final String guide;
  final String label;
  final VoidCallback onClick;
  final MainAxisAlignment alignment;

  const NavigateGuide(
      {super.key,
      required this.guide,
      required this.label,
      required this.onClick,
      this.alignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Text(guide),
          GestureDetector(
            onTap: onClick,
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
