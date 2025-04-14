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
  final Color defaultCellBackgroundColor;
  final Color defaultCellTextColor;
  final Color uiTextColor;
  final Color inputTextColor;
  final Color topBarColor;
  final Color topBarFontColor;
  final Color iconButtonColor;
  final Color disabledIconButtonColor;
  final Color mistakeTextColor;
  final Color inputNumberInputBackgroundColor;
  final Color inputNumberInputTextColor;
  final Color inputNumberInputBorderColor;
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
    this.uiTextColor = Colors.black,
    required this.inputTextColor,
    required this.topBarColor,
    required this.topBarFontColor,
    required this.iconButtonColor,
    this.disabledIconButtonColor = Colors.grey,
    required this.inputNumberInputBackgroundColor,
    required this.inputNumberInputTextColor,
    required this.inputNumberInputBorderColor,
    this.greyedNumberInputBackgroundColor = const Color(0xFFF5F5F5),
    this.greyedNumberInputTextColor = const Color(0xFFBDBDBD),
    this.greyedNumberInputBorderColor = const Color(0xFFE0E0E0),
    this.defaultCellBackgroundColor = Colors.white,
    this.defaultCellTextColor = Colors.black,
    this.mistakeTextColor = Colors.red,
    required this.clearNumberInputButtonBackgroundColor,
    required this.clearNumberInputButtonBorderColor,
    required this.clearNumberInputButtonTextColor,
    this.gridSquareBorderThickness = 0.5,
    this.backgroundImage,
  });

  // Predefined themes
  static final standard = SudokuTheme(
    name: 'Standard',
    primaryColor: Colors.white,
    secondaryColor: Colors.white,
    backgroundColor: Colors.white,
    gridLineColor: Colors.black54,
    selectedCellColor: const Color(0xFF7CB7E5),
    relatedCellColor: const Color(0xFFC3C9CE),
    rowSquareHighlightColor: const Color(0xFFD6ECFD),
    uiTextColor: Colors.black87,
    inputTextColor: Colors.black,
    topBarColor: Colors.transparent,
    topBarFontColor: Colors.black87,
    iconButtonColor: Colors.black87,
    inputNumberInputBackgroundColor: Colors.white,
    inputNumberInputTextColor: Colors.black,
    inputNumberInputBorderColor: Colors.black,
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
    defaultCellBackgroundColor: Colors.black54,
    defaultCellTextColor: Colors.white,
    uiTextColor: Colors.white,
    inputTextColor: Colors.white,
    topBarColor: Colors.transparent,
    topBarFontColor: Colors.white,
    iconButtonColor: Colors.white,
    inputNumberInputBackgroundColor: const Color(0xFF2C2C2C),
    inputNumberInputTextColor: const Color(0xFF666666),
    inputNumberInputBorderColor: const Color(0xFF444444),
    clearNumberInputButtonBackgroundColor: const Color(0xFF5C1919),
    clearNumberInputButtonBorderColor: const Color(0xFF8C2626),
    clearNumberInputButtonTextColor: const Color(0xFFFF4D4D),
  );

  static const japaneseSpringtime = SudokuTheme(
    name: 'Japanese Springtime',
    primaryColor: Color(0xFFFFB7C5), // Sakura pink
    secondaryColor: Color(0xFFE4A7B2), // Darker sakura
    backgroundColor: Colors.white,
    gridLineColor: Color(0xFF4A4A4A),
    selectedCellColor: Color(0xFFFFB1C0),
    relatedCellColor: Color(0xFFE9DADD),
    rowSquareHighlightColor: Color(0xFFFFF3F5),
    uiTextColor: Color(0xFF4A4A4A),
    inputTextColor: Color(0xFF4A4A4A),
    topBarColor: Colors.transparent,
    topBarFontColor: Color(0xFF4A4A4A),
    mistakeTextColor: Color(0xFF569F8B),
    iconButtonColor: Color(0xFF4A4A4A),
    inputNumberInputBackgroundColor: Color(0xFFFFB7C5),
    inputNumberInputTextColor: Colors.black,
    inputNumberInputBorderColor: Color(0xFFBA485E),
    clearNumberInputButtonBackgroundColor: Color(0xFF56FDCF),
    clearNumberInputButtonBorderColor: Color(0xFF569F8B),
    clearNumberInputButtonTextColor: Color(0xFF569F8B),
    backgroundImage: 'assets/images/sakura_bg.png',
  );

  static final retro = SudokuTheme(
    name: 'Retro',
    primaryColor: const Color(0xFF00FF00), // Bright green
    secondaryColor: const Color(0xFF008800), // Darker green
    backgroundColor: Colors.black,
    gridLineColor: const Color(0xFF00FF00),
    selectedCellColor: const Color(0xFF00FF00).withOpacity(0.5),
    relatedCellColor: const Color(0xFF00FF00).withOpacity(0.3),
    rowSquareHighlightColor: const Color(0xFF00FF00).withOpacity(0.2),
    uiTextColor: const Color(0xFF00FF00),
    inputTextColor: const Color(0xFF00FF00),
    topBarColor: Colors.transparent,
    topBarFontColor: const Color(0xFF00FF00),
    iconButtonColor: const Color(0xFF00FF00),
    inputNumberInputBackgroundColor: const Color(0xFF0A1A0A),
    inputNumberInputTextColor: const Color(0xFF1A331A),
    inputNumberInputBorderColor: const Color(0xFF143314),
    clearNumberInputButtonBackgroundColor: const Color(0xFF330000),
    clearNumberInputButtonBorderColor: const Color(0xFFFF0000),
    clearNumberInputButtonTextColor: const Color(0xFFFF0000),
  );

  static List<SudokuTheme> get allThemes => [
    standard,
    dark,
    japaneseSpringtime,
    retro,
  ];
} 