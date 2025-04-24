import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class PuzzleSettings extends ChangeNotifier {
  final SharedPreferences _prefs;
  final Random _random = Random();
  
  bool _showTimer = true;
  bool _showMistakes = true;
  bool _showRowSquareHighlighting = true;
  bool _showSameNumberHighlighting = true;
  bool _showFinishedNumbers = true;
  
  PuzzleSettings(this._prefs) {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    _showTimer = _prefs.getBool('showTimer') ?? true;
    _showMistakes = _prefs.getBool('showMistakes') ?? true;
    _showRowSquareHighlighting = _prefs.getBool('showRowSquareHighlighting') ?? true;
    _showSameNumberHighlighting = _prefs.getBool('showSameNumberHighlighting') ?? true;
    _showFinishedNumbers = _prefs.getBool('showFinishedNumbers') ?? true;
    notifyListeners();
  }
  
  Future<void> _saveSettings() async {
    await _prefs.setBool('showTimer', _showTimer);
    await _prefs.setBool('showMistakes', _showMistakes);
    await _prefs.setBool('showRowSquareHighlighting', _showRowSquareHighlighting);
    await _prefs.setBool('showSameNumberHighlighting', _showSameNumberHighlighting);
    await _prefs.setBool('showFinishedNumbers', _showFinishedNumbers);
  }
  
  bool get showTimer => _showTimer;
  bool get showMistakes => _showMistakes;
  bool get showRowSquareHighlighting => _showRowSquareHighlighting;
  bool get showSameNumberHighlighting => _showSameNumberHighlighting;
  bool get showFinishedNumbers => _showFinishedNumbers;
  
  // Random number of cells to remove between 30 and 60
  int get cellsToRemove => _random.nextInt(31) + 30;
  
  void toggleTimer() {
    _showTimer = !_showTimer;
    _saveSettings();
    notifyListeners();
  }
  
  void toggleMistakes() {
    _showMistakes = !_showMistakes;
    _saveSettings();
    notifyListeners();
  }
  
  void toggleRowSquareHighlighting() {
    _showRowSquareHighlighting = !_showRowSquareHighlighting;
    _saveSettings();
    notifyListeners();
  }
  
  void toggleSameNumberHighlighting() {
    _showSameNumberHighlighting = !_showSameNumberHighlighting;
    _saveSettings();
    notifyListeners();
  }
  
  void toggleFinishedNumbers() {
    _showFinishedNumbers = !_showFinishedNumbers;
    _saveSettings();
    notifyListeners();
  }
} 