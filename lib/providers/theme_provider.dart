import 'package:flutter/material.dart';
import '../models/theme_model.dart';

class ThemeProvider extends ChangeNotifier {
  SudokuTheme _currentTheme = SudokuTheme.standard;

  SudokuTheme get currentTheme => _currentTheme;

  void setTheme(SudokuTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
} 