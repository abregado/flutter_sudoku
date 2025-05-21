import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'puzzle_entry.dart';
import '../providers/puzzle_library_provider.dart';

class GameState extends ChangeNotifier {
  static const String _storageKey = 'game_state';
  
  // The current puzzle
  PuzzleEntry? _currentPuzzle;
  
  // Selected cell position
  int? selectedRow;
  int? selectedCol;
  
  // Undo stack
  final List<GameState> undoStack = [];
  
  Timer? _timer;
  bool _showTimer = true;
  
  PuzzleEntry? get currentPuzzle => _currentPuzzle;
  bool get showTimer => _showTimer;
  bool get isGeneratingNextPuzzle => false; // No longer needed
  
  // Constructor
  GameState() {
    _loadState();
  }
  
  // Copy constructor
  GameState.from(GameState other) {
    _currentPuzzle = other._currentPuzzle;
    selectedRow = other.selectedRow;
    selectedCol = other.selectedCol;
    _showTimer = other._showTimer;
  }
  
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = prefs.getString(_storageKey);
    
    if (stateJson != null) {
      final state = jsonDecode(stateJson) as Map<String, dynamic>;
      _showTimer = state['showTimer'] as bool;
    }
    
    notifyListeners();
  }
  
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    final state = {
      'showTimer': _showTimer,
    };
    
    await prefs.setString(_storageKey, jsonEncode(state));
  }
  
  void toggleTimer() {
    _showTimer = !_showTimer;
    _saveState();
    notifyListeners();
  }
  
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentPuzzle != null && !_currentPuzzle!.isCompleted) {
        _currentPuzzle!.timeSpent += const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }
  
  void stopTimer() {
    _timer?.cancel();
  }
  
  String get formattedTime {
    if (_currentPuzzle == null) return '00:00';
    final minutes = _currentPuzzle!.timeSpent.inMinutes;
    final seconds = _currentPuzzle!.timeSpent.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _saveState();
    super.dispose();
  }
  
  // Check if a move is valid
  bool isValidMove(int row, int col, int value) {
    if (_currentPuzzle == null) return false;
    return _currentPuzzle!.solution[row][col] == value;
  }
  
  // Make a move
  void makeMove(int? value) {
    if (_currentPuzzle == null || selectedRow == null || selectedCol == null) return;
    if (_currentPuzzle!.initialGrid[selectedRow!][selectedCol!] != 0) return;
    
    undoStack.add(GameState.from(this));
    
    final currentValue = _currentPuzzle!.currentGrid[selectedRow!][selectedCol!];
    _currentPuzzle!.currentGrid[selectedRow!][selectedCol!] = value ?? 0;
    
    if (value != null && !isValidMove(selectedRow!, selectedCol!, value)) {
      _currentPuzzle!.mistakes++;
    }
    
    notifyListeners();
  }
  
  // Select a cell
  void selectCell(int row, int col) {
    selectedRow = row;
    selectedCol = col;
    notifyListeners();
  }
  
  // Undo last move
  void undo() {
    if (undoStack.isEmpty || _currentPuzzle == null) return;
    
    GameState previousState = undoStack.removeLast();
    _currentPuzzle!.currentGrid = previousState._currentPuzzle!.currentGrid;
    _currentPuzzle!.mistakes = previousState._currentPuzzle!.mistakes;
    
    notifyListeners();
  }
  
  // Load a new puzzle
  PuzzleEntry? loadPuzzle(PuzzleEntry newPuzzle) {
    // Save current puzzle state if it exists
    final oldPuzzle = _currentPuzzle;
    
    // Stop timer if running
    stopTimer();
    
    // Load new puzzle
    _currentPuzzle = newPuzzle;
    selectedRow = null;
    selectedCol = null;
    undoStack.clear();
    
    // Start timer if puzzle is not completed
    if (!newPuzzle.isCompleted) {
      startTimer();
    }
    
    notifyListeners();
    return oldPuzzle;
  }
  
  // Check if game is complete
  bool get isComplete {
    if (_currentPuzzle == null) return false;
    
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_currentPuzzle!.currentGrid[i][j] != _currentPuzzle!.solution[i][j]) {
          return false;
        }
      }
    }
    
    // If we get here, the puzzle is complete
    _currentPuzzle!.isCompleted = true;
    _currentPuzzle!.completedAt = DateTime.now();
    stopTimer();
    notifyListeners();
    return true;
  }
} 