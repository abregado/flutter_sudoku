import 'package:flutter/material.dart';

class SudokuTheme {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color gridLineColor;
  final Color selectedCellColor;
  final Color relatedCellColor;
  final Color rowSquareHighlightColor;
  final Color textColor;
  final Color inputTextColor;
  final Color topBarColor;
  final Color topBarFontColor;
  final Color iconButtonColor;
  final Color greyedNumberInputBackgroundColor;
  final Color greyedNumberInputTextColor;
  final Color greyedNumberInputBorderColor;
  final Color clearNumberInputButtonBackgroundColor;
  final Color clearNumberInputButtonBorderColor;
  final Color clearNumberInputButtonTextColor;
  final double gridSquareBorderThickness;
  final String? backgroundImage;

  const SudokuTheme({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.gridLineColor,
    required this.selectedCellColor,
    required this.relatedCellColor,
    required this.rowSquareHighlightColor,
    required this.textColor,
    required this.inputTextColor,
    required this.topBarColor,
    required this.topBarFontColor,
    required this.iconButtonColor,
    required this.greyedNumberInputBackgroundColor,
    required this.greyedNumberInputTextColor,
    required this.greyedNumberInputBorderColor,
    required this.clearNumberInputButtonBackgroundColor,
    required this.clearNumberInputButtonBorderColor,
    required this.clearNumberInputButtonTextColor,
    this.gridSquareBorderThickness = 0.5,
    this.backgroundImage,
  });

  // Predefined themes
  static final standard = SudokuTheme(
    name: 'Standard',
    primaryColor: Colors.blue,
    secondaryColor: Colors.blue.shade200,
    backgroundColor: Colors.white,
    gridLineColor: Colors.black54,
    selectedCellColor: Colors.blue.withOpacity(0.5),
    relatedCellColor: Colors.blue.withOpacity(0.3),
    rowSquareHighlightColor: Colors.blue.withOpacity(0.2),
    textColor: Colors.black87,
    inputTextColor: Colors.blue.shade900,
    topBarColor: Colors.transparent,
    topBarFontColor: Colors.black87,
    iconButtonColor: Colors.black87,
    greyedNumberInputBackgroundColor: Color(0xFFF5F5F5),
    greyedNumberInputTextColor: Color(0xFFBDBDBD),
    greyedNumberInputBorderColor: Color(0xFFE0E0E0),
    clearNumberInputButtonBackgroundColor: Colors.red.shade100,
    clearNumberInputButtonBorderColor: Colors.red.shade300,
    clearNumberInputButtonTextColor: Colors.red.shade700,
  );

  static final dark = SudokuTheme(
    name: 'Dark',
    primaryColor: Colors.blueGrey,
    secondaryColor: Colors.blueGrey.shade700,
    backgroundColor: Colors.grey.shade900,
    gridLineColor: Colors.white70,
    selectedCellColor: Colors.blueGrey.withOpacity(0.5),
    relatedCellColor: Colors.blueGrey.withOpacity(0.3),
    rowSquareHighlightColor: Colors.blueGrey.withOpacity(0.2),
    textColor: Colors.white,
    inputTextColor: Colors.white,
    topBarColor: Colors.transparent,
    topBarFontColor: Colors.white,
    iconButtonColor: Colors.white,
    greyedNumberInputBackgroundColor: Color(0xFF2C2C2C),
    greyedNumberInputTextColor: Color(0xFF666666),
    greyedNumberInputBorderColor: Color(0xFF444444),
    clearNumberInputButtonBackgroundColor: Color(0xFF5C1919),
    clearNumberInputButtonBorderColor: Color(0xFF8C2626),
    clearNumberInputButtonTextColor: Color(0xFFFF4D4D),
  );

  static final japaneseSpringtime = SudokuTheme(
    name: 'Japanese Springtime',
    primaryColor: Color(0xFFFFB7C5), // Sakura pink
    secondaryColor: Color(0xFFE4A7B2), // Darker sakura
    backgroundColor: Color(0xFFFFF0F5), // Very light pink
    gridLineColor: Color(0xFF4A4A4A),
    selectedCellColor: Color(0xFFFFB7C5).withOpacity(0.5),
    relatedCellColor: Color(0xFFFFB7C5).withOpacity(0.3),
    rowSquareHighlightColor: Color(0xFFFFB7C5).withOpacity(0.2),
    textColor: Color(0xFF4A4A4A),
    inputTextColor: Color(0xFF4A4A4A),
    topBarColor: Colors.transparent,
    topBarFontColor: Color(0xFF4A4A4A),
    iconButtonColor: Color(0xFF4A4A4A),
    greyedNumberInputBackgroundColor: Color(0xFFF8E7EA),
    greyedNumberInputTextColor: Color(0xFFBEA4A8),
    greyedNumberInputBorderColor: Color(0xFFE5D1D4),
    clearNumberInputButtonBackgroundColor: Color(0xFFFF6B6B),
    clearNumberInputButtonBorderColor: Color(0xFFFF8787),
    clearNumberInputButtonTextColor: Colors.white,
    backgroundImage: 'assets/images/sakura_bg.png',
  );

  static final retro = SudokuTheme(
    name: 'Retro',
    primaryColor: Color(0xFF00FF00), // Bright green
    secondaryColor: Color(0xFF008800), // Darker green
    backgroundColor: Colors.black,
    gridLineColor: Color(0xFF00FF00),
    selectedCellColor: Color(0xFF00FF00).withOpacity(0.5),
    relatedCellColor: Color(0xFF00FF00).withOpacity(0.3),
    rowSquareHighlightColor: Color(0xFF00FF00).withOpacity(0.2),
    textColor: Color(0xFF00FF00),
    inputTextColor: Color(0xFF00FF00),
    topBarColor: Colors.transparent,
    topBarFontColor: Color(0xFF00FF00),
    iconButtonColor: Color(0xFF00FF00),
    greyedNumberInputBackgroundColor: Color(0xFF0A1A0A),
    greyedNumberInputTextColor: Color(0xFF1A331A),
    greyedNumberInputBorderColor: Color(0xFF143314),
    clearNumberInputButtonBackgroundColor: Color(0xFF330000),
    clearNumberInputButtonBorderColor: Color(0xFFFF0000),
    clearNumberInputButtonTextColor: Color(0xFFFF0000),
  );

  static List<SudokuTheme> get allThemes => [
    standard,
    dark,
    japaneseSpringtime,
    retro,
  ];
} 