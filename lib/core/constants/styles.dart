import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  // Define TextStyle for Montserrat
  static TextStyle montserrat({
    double fontSize = 16,
    double? height,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );
  }

  // Define TextStyle for Figtree
  static TextStyle figtree({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.figtree(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Define a TextStyle for headings using Montserrat
  static TextStyle heading({
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.w700,
    Color color = Colors.black,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Define a TextStyle for subheadings using Figtree
  static TextStyle subheading({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w600,
    Color color = Colors.black,
  }) {
    return GoogleFonts.figtree(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Define body text with Montserrat (default)
  static TextStyle body({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Define caption text with Figtree (smaller font size)
  static TextStyle caption({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.grey,
  }) {
    return GoogleFonts.figtree(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
