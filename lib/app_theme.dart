import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _onError = Colors.red;

  static const Color _lightSurface = Color(0xffffffff);
  static const Color _lightBackground = Color(0xfff5f6f7);
  static const Color _lightPrimaryText = Color(0xff162a72);
  static const Color _lightSecondaryText = Color(0xffaab2cb);
  static const Color _lightAccent = Color(0xff3266eb);

  static const Color _darkSurface = Color(0xff273152);
  static const Color _darkBackground = Color(0xff202844);
  static const Color _darkPrimaryText = Color(0xffffffff);
  static const Color _darkSecondaryText = Color(0xff99a0b3);
  static const Color _darkAccent = Color(0xff37b8f4);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightBackground,
    colorScheme: const ColorScheme.light(
      surface: _lightSurface,
      primary: _lightPrimaryText,
      secondary: _lightSecondaryText,
      primaryContainer: _lightAccent,
      onError: _onError,
    ),
    appBarTheme: const AppBarTheme(elevation: 0.0),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: _darkBackground,
    colorScheme: const ColorScheme.light(
      surface: _darkSurface,
      primary: _darkPrimaryText,
      secondary: _darkSecondaryText,
      primaryContainer: _darkAccent,
      onError: _onError,
    ),
    appBarTheme: const AppBarTheme(elevation: 0.0),
  );
}

// background - kinda obvious
// surface - cards, botton navbar, etc that appear directly over the background
// primary - main text, most contrast
// secondary - description and tips, less contrast
// primarycontainer (replace primaryContainer) (accent) - color that pops ... contd. below
// on the surface/bg for the form border or whatever, where color is required
