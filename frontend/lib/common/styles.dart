import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'quarticle.dart';

class Colours {
  static const Color cvTeal = Color(0xFF008080);
  static const Color cvWhite = Color(0xC0FFFFFF);

  static const Color cvGlassyTeal = Color(0x60204040);
  static const Color cvGlassyCyan = Color(0x60208080);
  static const Color cvGlassyTurquoise = Color(0x6020D0D0);
  static const Color cvGlassyMahogany = Color(0x10E05820);
  static const Color cvGlassyVermillion = Color(0x60E05820);
  static const Color cvGlassySilver = Color(0x20C0C0C0);
  static const Color cvGlassyBlack = Color(0x60000000);
}

class TextStyles {
  static TextStyle headbar = GoogleFonts.comfortaa(
    fontSize: 14,
    fontWeight: FontWeight.w900,
    letterSpacing: 9,
    color: Colours.cvTeal,
  );

  static TextStyle name = GoogleFonts.comfortaa(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: Colours.cvWhite,
  );

  static TextStyle tagline = GoogleFonts.comfortaa(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colours.cvWhite,
  );

  static TextStyle qButton = GoogleFonts.comfortaa(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colours.cvWhite,
  );

  static TextStyle qButtonMid = GoogleFonts.comfortaa(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colours.cvWhite,
  );

  static TextStyle qButtonBig = GoogleFonts.comfortaa(
    fontSize: 27,
    fontWeight: FontWeight.w700,
    color: Colours.cvWhite,
  );

  static TextStyle message = GoogleFonts.comfortaa(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colours.cvWhite,
  );
}

class QStyles {
  static QuarticleStyle label = const QuarticleStyle(
    fillColour: Colours.cvGlassyTeal,
    strokeColour: Colours.cvGlassyTeal,
    shadowColour: Colours.cvGlassyTeal,
  );
  static QuarticleStyle input = const QuarticleStyle(
    fillColour: Colours.cvGlassyVermillion,
    strokeColour: Colours.cvGlassyVermillion,
    shadowColour: Colours.cvGlassyVermillion,
  );
  static QuarticleStyle tray = const QuarticleStyle(
    fillColour: Colours.cvGlassySilver,
    strokeColour: Colours.cvGlassySilver,
    shadowColour: Colours.cvGlassySilver,
  );
  static QuarticleStyle dark = const QuarticleStyle(
    fillColour: Colours.cvGlassyBlack,
    strokeColour: Colours.cvGlassyBlack,
    shadowColour: Colours.cvGlassyBlack,
  );
  static QuarticleStyle turquoise = const QuarticleStyle(
    fillColour: Colours.cvGlassyTurquoise,
    strokeColour: Colours.cvGlassyTurquoise,
    shadowColour: Colours.cvGlassyTurquoise,
  );
  static QuarticleStyle cyan = const QuarticleStyle(
    fillColour: Colours.cvGlassyCyan,
    strokeColour: Colours.cvGlassyCyan,
    shadowColour: Colours.cvGlassyCyan,
  );
  static QuarticleStyle mahogany = const QuarticleStyle(
    fillColour: Colours.cvGlassyMahogany,
    strokeColour: Colours.cvGlassyMahogany,
    shadowColour: Colours.cvGlassyMahogany,
  );
  static QuarticleStyle highlighted = const QuarticleStyle(
    fillColour: Colours.cvGlassySilver,
    strokeColour: Colours.cvGlassyTurquoise,
    shadowColour: Colours.cvGlassySilver,
    strokeWeight: 5,
  );
}
