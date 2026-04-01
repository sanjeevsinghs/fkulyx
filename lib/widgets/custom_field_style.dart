// import 'package:flutter/material.dart';

// class CustomFieldStyle {
//   static Color hexColor(String hex) {
//     final normalized = hex.replaceAll('#', '').trim();

//     if (normalized.length == 6) {
//       return Color(int.parse('0xFF$normalized'));
//     }

//     if (normalized.length == 8) {
//       return Color(int.parse('0x$normalized'));
//     }

//     return Colors.black;
//   }

//   static TextStyle robotoStyle({
//     required double textSize,
//     required Color textColor,
//     FontWeight? fontWeight,
//     double? height,
//   }) {
//     return TextStyle(
//       fontFamily: 'roboto',
//       fontSize: textSize,
//       color: textColor,
//       fontWeight: fontWeight ?? FontWeight.w400,
//       height: height,
//     );
//   }
// }

// Color HexColor(String hex) => CustomFieldStyle.hexColor(hex);

// TextStyle robotoStyle({
//   required double textSize,
//   required Color textColor,
//   FontWeight? fontWeight,
//   double? height,
// }) =>
//     CustomFieldStyle.robotoStyle(
//       textSize: textSize,
//       textColor: textColor,
//       fontWeight: fontWeight,
//       height: height,
//     );
