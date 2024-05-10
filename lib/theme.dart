import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
const Color couleur1 = Color(0xFFCA8E55);
const Color couleur2 = Color(0xFFEECCAC);
const Color couleur3 = Color(0xFFE0D4F4);
const Color couleur4 = Color(0xFF595E95);
const Color couleur5 = Color(0xFFC0CB9C);
const primaryClr= couleur5;

class Themes{

   static final light= ThemeData(
        primaryColor: couleur5,
        brightness: Brightness.light 
   );
   static final dark=ThemeData(
        primaryColor:couleur4,
        brightness: Brightness.dark   
    ); 
}
TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
 textStyle:TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black
 )
  );
}
TextStyle get headingStyle{
  return GoogleFonts.lato(
 textStyle:TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold
 )
  );
}
TextStyle get titleStyle{
  return GoogleFonts.lato(
 textStyle:TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  
 )
  );
}
TextStyle get subtitleStyle{
  return GoogleFonts.lato(
 textStyle:TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  
 )
  );
}