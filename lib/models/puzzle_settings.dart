import 'package:flutter/foundation.dart';

enum Difficulty {
  easy,
  medium,
  hard,
  expert
}

class PuzzleSettings extends ChangeNotifier {
  Difficulty _difficulty = Difficulty.medium;
  bool _showTimer = true;
  bool _showMistakes = true;
  
  Difficulty get difficulty => _difficulty;
  bool get showTimer => _showTimer;
  bool get showMistakes => _showMistakes;
  
  // Number of cells to remove based on difficulty
  int get cellsToRemove {
    switch (_difficulty) {
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
    _difficulty = difficulty;
    notifyListeners();
  }
  
  void toggleTimer() {
    _showTimer = !_showTimer;
    notifyListeners();
  }
  
  void toggleMistakes() {
    _showMistakes = !_showMistakes;
    notifyListeners();
  }
} 