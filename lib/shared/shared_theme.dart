import 'package:flutter/material.dart';

ThemeData get standardTheme {
  //1
  return ThemeData.from(colorScheme: ColorScheme(
    primary: Color(0xffffdd31),
    primaryVariant: Color(0xffc8ac00),
    secondary: Color(0xff7c461f),
    secondaryVariant: Color(0xff4c1d00),
    onPrimary: Color(0xff000000),
    onSecondary: Color(0xffffffff),
    background: Color(0xfffffbc8),
    error: Color(0xffcc0000),
    onBackground: Color(0xff000000),
    surface: Color(0xffffffff),
    onSurface: Color(0xff000000),
    brightness: Brightness.light,
    // todo: wtf is this
    onError: Color(0xffffffff),
  ));
}