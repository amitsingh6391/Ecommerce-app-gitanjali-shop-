import 'package:flutter/material.dart';

const Color yellow = Color(0xFFFFC0CB);
const Color mediumYellow = Color(0xFFFFB6C1);
const Color darkYellow = Color(0xffFF69B4);
const Color transparentYellow = Color.fromRGBO(255, 182, 193, 0.7);
const Color darkGrey = Color(0xff000000);

const LinearGradient mainButton = LinearGradient(
    colors: [mediumYellow, Colors.pinkAccent],
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter);

const List<BoxShadow> shadow = [
  BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6)
];

screenAwareSize(int size, BuildContext context) {
  double baseHeight = 640.0;
  return size * MediaQuery.of(context).size.height / baseHeight;
}
