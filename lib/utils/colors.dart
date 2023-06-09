import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 167, 108, 255);
const disablePrimaryColor = Color.fromARGB(255, 209, 195, 230);
const secondaryColor = Color.fromARGB(255, 177, 225, 255);
const backgroundColor = Color.fromARGB(255, 175, 180, 255);
const greyColor = Color.fromARGB(255, 233, 233, 233);
const LinearGradient specialColorVertial = LinearGradient(
    colors: [secondaryColor, primaryColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);
const LinearGradient specialColorHorizontal =
    LinearGradient(colors: [secondaryColor, primaryColor]);
const LinearGradient specialColorDiagonal = LinearGradient(
    colors: [secondaryColor, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);
