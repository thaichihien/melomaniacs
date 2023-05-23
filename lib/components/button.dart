import 'package:flutter/material.dart';
import 'package:melomaniacs/utils/colors.dart';

class LargeButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onClick;
  final bool loadingState;

  const LargeButton(
      {super.key,
      required this.buttonText,
      required this.onClick,
      this.loadingState = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!loadingState) {
          onClick();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            color: primaryColor),
        child: loadingState
            ? const SizedBox(
              height: 24,
              width: 24,
              child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    
                  ),
                ),
            )
            : Text(
                buttonText,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
      ),
    );
  }
}
