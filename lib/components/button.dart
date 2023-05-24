import 'package:flutter/material.dart';
import 'package:melomaniacs/utils/colors.dart';

class LargeButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onClick;
  final bool loadingState;
  final Color color;

  const LargeButton(
      {super.key,
      required this.buttonText,
      required this.onClick,
      this.loadingState = false,
      this.color = primaryColor});

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
        decoration: ShapeDecoration(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            color: color),
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

class SmallButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onClick;
  final Color color;

  const SmallButton(
      {super.key,
      required this.buttonText,
      required this.onClick,
      this.color = primaryColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: color)))),
      child:
          Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class LikeButton extends StatelessWidget {
  final bool liked;
  final int amount;

  const LikeButton({super.key, required this.liked, required this.amount});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor:
                liked ? MaterialStateProperty.all<Color>(primaryColor) : null,
            foregroundColor: liked
                ? MaterialStateProperty.all<Color>(secondaryColor)
                : MaterialStateProperty.all<Color>(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(width: 3, color: primaryColor)))),
        child: Row(
          children: [
            const Icon(Icons.favorite),
            const SizedBox(
              width: 5,
            ),
            Text(amount.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ));
  }
}
