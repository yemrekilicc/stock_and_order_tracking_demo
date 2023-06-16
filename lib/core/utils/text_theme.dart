import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';

class CustomTextStyle {
  static TextStyle headline1 = GoogleFonts.almarai(
    fontSize: 100.sp,
    fontWeight: FontWeight.w400,
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.9),
        offset: Offset(3, 3),
        blurRadius: 8,
      ),
    ],
  );


  static TextStyle loginHeadline = GoogleFonts.mulish(
    fontSize: 15.sp,
    color: Colors.black,
  );
  static TextStyle loginGiris = GoogleFonts.mulish(
    fontSize: 30,
    color: Colors.black,
    fontWeight: FontWeight.w400
  );
  static TextStyle loginLabel = GoogleFonts.roboto(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.w400
  );
  static TextStyle textFieldHintStyle = TextStyle(
    fontFamily: 'CenturyGothic',
    fontSize: 15.sp,
    color: Colors.grey,
  );
  static TextStyle textFieldStyle = GoogleFonts.mulish(
    fontSize: 15,
    color: Colors.black,
  );
  static TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: Colors.white,
  );

  static TextStyle homePageTableTextStyle = GoogleFonts.roboto(
      fontSize: 24.sp,
      color: Colors.black,
      fontWeight: FontWeight.w400
  );
  static TextStyle navigationLabelStyle = GoogleFonts.roboto(
      fontSize: 12.sp,
      color: Colors.black,
      fontWeight: FontWeight.w400
  );
  static TextStyle homePageTableSubTextStyle2 = GoogleFonts.roboto(
      fontSize: 12.sp,
      color: Color(0xffBEBEBE),
      fontWeight: FontWeight.w400
  );
  static TextStyle pageTitle = GoogleFonts.roboto(
      fontSize: 24.sp,
      color: Colors.black,
      fontWeight: FontWeight.w700
  );
}
