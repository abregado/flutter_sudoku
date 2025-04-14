import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Difficulty {
  easy,
  medium,
  hard,
  expert
}

class PuzzleSettings extends ChangeNotifier {
  final SharedPreferences _prefs;
  
  Difficulty _nextDifficulty = Difficulty.medium;
  Difficulty _currentDifficulty = Difficulty.medium;
  bool _showTimer = true;
  bool _showMistakes = true;
  bool _showRowSquareHighlighting = true;
  bool _showSameNumberHighlighting = true;
  bool _showFinishedNumbers = true;
  
  PuzzleSettings(this._prefs) {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    _nextDifficulty = Difficulty.values[_prefs.getInt('n_difficulty') ?? 1];
    _currentDifficulty = Difficulty.values[_prefs.getInt('c_difficulty') ?? 1];
    _showTimer = _prefs.getBool('showTimer') ?? true;
    _showMistakes = _prefs.getBool('showMistakes') ?? true;
    _showRowSquareHighlighting = _prefs.getBool('showRowSquareHighlighting') ?? true;
    _showSameNumberHighlighting = _prefs.getBool('showSameNumberHighlighting') ?? true;
    _showFinishedNumbers = _prefs.getBool('showFinishedNumbers') ?? true;
    notifyListeners();
  }
  
  Future<void> _saveSettings() async {
    await _prefs.setInt('n_difficulty', _nextDifficulty.index);
    await _prefs.setInt('c_difficulty', _currentDifficulty.index);
    await _prefs.setBool('showTimer', _showTimer);
    await _prefs.setBool('showMistakes', _showMistakes);
    await _prefs.setBool('showRowSquareHighlighting', _showRowSquareHighlighting);
    await _prefs.setBool('showSameNumberHighlighting', _showSameNumberHighlighting);
    await _prefs.setBool('showFinishedNumbers', _showFinishedNumbers);
  }
  
  Difficulty get difficulty => _nextDifficulty;
  Difficulty get currentDifficulty => _currentDifficulty;
  bool get showTimer => _showTimer;
  bool get showMistakes => _showMistakes;
  bool get showRowSquareHighlighting => _showRowSquareHighlighting;
  bool get showSameNumberHighlighting => _showSameNumberHighlighting;
  bool get showFinishedNumbers => _showFinishedNumbers;
  
  // Number of cells to remove based on difficulty
  int get cellsToRemove {
    switch (_nextDifficulty) {
      case Difficulty.easy:
        return 30; // 51 cells filled
      case Difficulty.medium:
        return 40; // 41 cells filled
      case Difficulty.hard:
        return 50; // 31 cells filled
      case Difficulty.expert:
        return 60; // 21 cells filled
    }
  }
  
  void setDifficulty(Difficulty difficulty) {
    _nextDifficulty = difficulty;
    _saveSettings();
    notifyListeners();
  }

  void updateCurrentDifficulty(){
    _currentDifficulty = _nextDifficulty;
    _saveSettings();
    notifyListeners();
  }
  
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