import 'package:contact_hub/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    fontFamily: GoogleFonts.aBeeZee().fontFamily,
    primarySwatch: Colors.deepPurple,
    iconTheme: IconThemeData(color: AppColor.kBlack),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      toolbarHeight: 80,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColor.kBlack,
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.dancingScript().fontFamily,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showUnselectedLabels: true,
      unselectedItemColor: AppColor.kBlack,
      unselectedLabelStyle: TextStyle(color: AppColor.kBlack),
      selectedLabelStyle: TextStyle(color: AppColor.kBlack),
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    primarySwatch: Colors.deepPurple,
    fontFamily: GoogleFonts.aBeeZee().fontFamily,
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: AppColor.kWhite),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      toolbarHeight: 80,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColor.kWhite,
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.dancingScript().fontFamily,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      showUnselectedLabels: true,
      unselectedItemColor: AppColor.kWhite,
      unselectedLabelStyle: TextStyle(color: AppColor.kWhite),
      selectedLabelStyle: TextStyle(color: AppColor.kWhite),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
    ),
  );
}
