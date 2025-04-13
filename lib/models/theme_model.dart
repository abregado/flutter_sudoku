import 'package:flutter/material.dart';

class SudokuTheme {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color gridLineColor;
  final Color selectedCellColor;
  final Color relatedCellColor;
  final Color textColor;
  final Color inputTextColor;
  final String? backgroundImage;

  const SudokuTheme({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.gridLineColor,
    required this.selectedCellColor,
    required this.relatedCellColor,
    required this.textColor,
    required this.inputTextColor,
    this.backgroundImage,
  });

  // Predefined themes
  static final standard = SudokuTheme(
    name: 'Standard',
    primaryColor: Colors.blue,
    secondaryColor: Colors.blue.shade200,
    backgroundColor: Colors.white,
    gridLineColor: Colors.black54,
    selectedCellColor: Colors.blue.withOpacity(0.6),
    relatedCellColor: Colors.grey.withOpacity(0.5),
    textColor: Colors.black87,
    inputTextColor: Colors.blue.shade900,
  );

  static final dark = SudokuTheme(
    name: 'Dark',
    primaryColor: Colors.blueGrey,
    secondaryColor: Colors.blueGrey.shade700,
    backgroundColor: Colors.grey.shade900,
    gridLineColor: Colors.white70,
    selectedCellColor: Colors.blueGrey.withOpacity(0.6),
    relatedCellColor: Colors.blueGrey.withOpacity(0.5),
    textColor: Colors.white,
    inputTextColor: Colors.white,
  );

  static final japaneseSpringtime = SudokuTheme(
    name: 'Japanese Springtime',
    primaryColor: Color(0xFFFFB7C5), // Sakura pink
    secondaryColor: Color(0xFFE4A7B2), // Darker sakura
    backgroundColor: Color(0xFFFFF0F5), // Very light pink
    gridLineColor: Color(0xFF4A4A4A),
    selectedCellColor: Color(0xFFFFB7C5).withOpacity(0.6),
    relatedCellColor: Color(0xFFFFB7C5).withOpacity(0.5),
    textColor: Color(0xFF4A4A4A),
    inputTextColor: Color(0xFF4A4A4A),
    backgroundImage: 'assets/images/sakura_bg.png',
  );

  static final retro = SudokuTheme(
    name: 'Retro',
    primaryColor: Color(0xFF00FF00), // Bright green
    secondaryColor: Color(0xFF008800), // Darker green
    backgroundColor: Colors.black,
    gridLineColor: Color(0xFF00FF00),
    selectedCellColor: Color(0xFF00FF00).withOpacity(0.3),
    relatedCellColor: Color(0xFF00FF00).withOpacity(0.1),
    textColor: Color(0xFF00FF00),
    inputTextColor: Color(0xFF00FF00),
  );

  static List<SudokuTheme> get allThemes => [
    standard,
    dark,
    japaneseSpringtime,
    retro,
  ];
} 