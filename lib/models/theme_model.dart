import 'package:flutter/material.dart';

class SudokuTheme {
  final String name;
  final Color backgroundColor;
  final Color gridLineColor;
  final Color selectedCellColor;
  final Color relatedCellColor;
  final Color rowSquareHighlightColor;
  final Color defaultCellBackgroundColor;
  final Color defaultCellTextColor;
  final Color uiTextColor;
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
    required this.backgroundColor,
    required this.gridLineColor,
    required this.selectedCellColor,
    required this.relatedCellColor,
    required this.rowSquareHighlightColor,
    this.uiTextColor = Colors.black,
    this.topBarColor = Colors.transparent,
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
    backgroundColor: Colors.white,
    gridLineColor: Colors.black54,
    selectedCellColor: const Color(0xFF7CB7E5),
    relatedCellColor: const Color(0xFFC3C9CE),
    rowSquareHighlightColor: const Color(0xFFD6ECFD),
    uiTextColor: Colors.black87,
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
    backgroundColor: Colors.black,
    gridLineColor: Colors.grey.shade400,
    selectedCellColor: Colors.grey.shade700,
    relatedCellColor: Colors.grey.shade800,
    rowSquareHighlightColor: Colors.grey.shade900,
    defaultCellBackgroundColor: Colors.black,
    defaultCellTextColor: Colors.white,
    uiTextColor: Colors.white,
    topBarFontColor: Colors.grey.shade300,
    iconButtonColor: Colors.grey.shade300,
    disabledIconButtonColor: Colors.grey.shade500,
    inputNumberInputBackgroundColor: Colors.grey.shade900,
    inputNumberInputTextColor: Colors.white,
    inputNumberInputBorderColor: Colors.grey.shade600,
    greyedNumberInputBackgroundColor: Colors.black,
    greyedNumberInputTextColor: Colors.grey.shade900,
    greyedNumberInputBorderColor: Colors.grey.shade800,
    clearNumberInputButtonBackgroundColor: Colors.black,
    clearNumberInputButtonBorderColor: Colors.red,
    clearNumberInputButtonTextColor: Colors.red,
  );

  static const japaneseSpringtime = SudokuTheme(
    name: 'Sakura',
    backgroundColor: Colors.white,
    gridLineColor: Color(0xFF4A4A4A),
    selectedCellColor: Color(0xFFFFB1C0),
    relatedCellColor: Color(0xFFE9DADD),
    rowSquareHighlightColor: Color(0xFFFFF3F5),
    uiTextColor: Color(0xFF4A4A4A),
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
    backgroundColor: Colors.black,
    gridLineColor: Colors.green.shade900,
    selectedCellColor: const Color(0xFF074503),
    relatedCellColor: const Color(0xFF1E1E1E),
    rowSquareHighlightColor: const Color(0xFF063300),
    defaultCellBackgroundColor: Colors.black,
    defaultCellTextColor: const Color(0xFF7FDA6B),
    uiTextColor: Colors.green.shade500,
    topBarFontColor: Colors.green.shade500,
    iconButtonColor: Colors.green.shade500,
    disabledIconButtonColor: Colors.green.shade900,
    inputNumberInputBackgroundColor: Colors.grey.shade900,
    inputNumberInputTextColor: Colors.green.shade500,
    inputNumberInputBorderColor: Colors.green.shade500,
    greyedNumberInputBackgroundColor: Colors.black,
    greyedNumberInputTextColor: Colors.green.shade900,
    greyedNumberInputBorderColor: Colors.grey.shade900,
    clearNumberInputButtonBackgroundColor: Colors.black,
    clearNumberInputButtonBorderColor: const Color(0xFFEC6328),
    clearNumberInputButtonTextColor: const Color(0xFFEC6328),
    mistakeTextColor: const Color(0xFFE4936F),
  );

  static List<SudokuTheme> get allThemes => [
    standard,
    dark,
    japaneseSpringtime,
    retro,
  ];
} 