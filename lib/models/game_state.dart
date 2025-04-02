import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameState extends ChangeNotifier {
  static const String _storageKey = 'game_state';
  
  // The Sudoku grid (9x9)
  List<List<int?>> grid = List.generate(9, (_) => List.filled(9, null));
  
  // The solution grid
  List<List<int>> solution = List.generate(9, (_) => List.filled(9, 0));
  
  // The initial grid (to track which cells were given)
  List<List<bool>> initialCells = List.generate(9, (_) => List.filled(9, false));
  
  // Selected cell position
  int? selectedRow;
  int? selectedCol;
  
  // Mistake counter
  int mistakes = 0;
  
  // Game start time
  DateTime? startTime;
  
  // Undo stack
  final List<GameState> undoStack = [];
  
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _showTimer = true;
  Duration? _completionTime;
  int _completionMistakes = 0;
  
  Duration get elapsedTime => _elapsedTime;
  bool get showTimer => _showTimer;
  Duration? get completionTime => _completionTime;
  int get completionMistakes => _completionMistakes;
  
  // Constructor
  GameState() {
    _loadState();
  }
  
  // Copy constructor
  GameState.from(GameState other) {
    grid = List.generate(9, (i) => List.from(other.grid[i]));
    solution = List.generate(9, (i) => List.from(other.solution[i]));
    initialCells = List.generate(9, (i) => List.from(other.initialCells[i]));
    selectedRow = other.selectedRow;
    selectedCol = other.selectedCol;
    mistakes = other.mistakes;
    startTime = other.startTime;
    _elapsedTime = other._elapsedTime;
    _showTimer = other._showTimer;
    _completionTime = other._completionTime;
    _completionMistakes = other._completionMistakes;
  }
  
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = prefs.getString(_storageKey);
    
    if (stateJson != null) {
      final state = json.decode(stateJson);
      
      // Load grid
      final gridData = state['grid'] as List;
      grid = List.generate(9, (i) => 
        List.generate(9, (j) => gridData[i][j] as int?));
      
      // Load solution
      final solutionData = state['solution'] as List;
      solution = List.generate(9, (i) => 
        List.generate(9, (j) => solutionData[i][j] as int));
      
      // Load initial cells
      final initialData = state['initialCells'] as List;
      initialCells = List.generate(9, (i) => 
        List.generate(9, (j) => initialData[i][j] as bool));
      
      // Load other state
      selectedRow = state['selectedRow'] as int?;
      selectedCol = state['selectedCol'] as int?;
      mistakes = state['mistakes'] as int;
      startTime = state['startTime'] != null ? 
        DateTime.parse(state['startTime'] as String) : null;
      _elapsedTime = Duration(seconds: state['elapsedTime'] as int);
      _showTimer = state['showTimer'] as bool;
      _completionTime = state['completionTime'] != null ?
        Duration(seconds: state['completionTime'] as int) : null;
      _completionMistakes = state['completionMistakes'] as int;
      
      notifyListeners();
    }
  }
  
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    
    final state = {
      'grid': grid,
      'solution': solution,
      'initialCells': initialCells,
      'selectedRow': selectedRow,
      'selectedCol': selectedCol,
      'mistakes': mistakes,
      'startTime': startTime?.toIso8601String(),
      'elapsedTime': _elapsedTime.inSeconds,
      'showTimer': _showTimer,
      'completionTime': _completionTime?.inSeconds,
      'completionMistakes': _completionMistakes,
    };
    
    await prefs.setString(_storageKey, json.encode(state));
  }
  
  void toggleTimer() {
    _showTimer = !_showTimer;
    _saveState();
    notifyListeners();
  }
  
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime += const Duration(seconds: 1);
      _saveState();
      notifyListeners();
    });
  }
  
  void stopTimer() {
    _timer?.cancel();
  }
  
  void resetTimer() {
    stopTimer();
    _elapsedTime = Duration.zero;
    _completionTime = null;
    _completionMistakes = 0;
    _saveState();
    notifyListeners();
  }
  
  String get formattedTime {
    final minutes = _elapsedTime.inMinutes;
    final seconds = _elapsedTime.inSeconds % 60;
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
    // Check row
    for (int i = 0; i < 9; i++) {
      if (i != col && grid[row][i] == value) return false;
    }
    
    // Check column
    for (int i = 0; i < 9; i++) {
      if (i != row && grid[i][col] == value) return false;
    }
    
    // Check 3x3 box
    int boxRow = (row ~/ 3) * 3;
    int boxCol = (col ~/ 3) * 3;
    for (int i = boxRow; i < boxRow + 3; i++) {
      for (int j = boxCol; j < boxCol + 3; j++) {
        if (i != row && j != col && grid[i][j] == value) return false;
      }
    }
    
    return true;
  }
  
  // Make a move
  void makeMove(int? value) {
    if (selectedRow == null || selectedCol == null) return;
    if (initialCells[selectedRow!][selectedCol!]) return;
    
    undoStack.add(GameState.from(this));
    
    grid[selectedRow!][selectedCol!] = value;
    
    if (value != null && !isValidMove(selectedRow!, selectedCol!, value)) {
      mistakes++;
    }
    
    _saveState();
    notifyListeners();
  }
  
  // Select a cell
  void selectCell(int row, int col) {
    selectedRow = row;
    selectedCol = col;
    _saveState();
    notifyListeners();
  }
  
  // Undo last move
  void undo() {
    if (undoStack.isEmpty) return;
    
    GameState previousState = undoStack.removeLast();
    grid = previousState.grid;
    mistakes = previousState.mistakes;
    
    _saveState();
    notifyListeners();
  }
  
  // Start new game with generated puzzle
  void startNewGameWithPuzzle(List<List<int?>> newGrid, List<List<int>> newSolution) {
    grid = newGrid;
    solution = newSolution;
    initialCells = List.generate(9, (i) => 
      List.generate(9, (j) => grid[i][j] != null));
    selectedRow = null;
    selectedCol = null;
    mistakes = 0;
    startTime = DateTime.now();
    undoStack.clear();
    
    _saveState();
    notifyListeners();
  }
  
  // Start new game (empty grid)
  void newGame() {
    grid = List.generate(9, (_) => List.filled(9, null));
    solution = List.generate(9, (_) => List.filled(9, 0));
    initialCells = List.generate(9, (_) => List.filled(9, false));
    selectedRow = null;
    selectedCol = null;
    mistakes = 0;
    startTime = DateTime.now();
    undoStack.clear();
    
    _saveState();
    notifyListeners();
  }
  
  // Check if game is complete
  bool get isComplete {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] == null) return false;
      }
    }
    
    // If we get here, the puzzle is complete
    _completionTime = _elapsedTime;
    _completionMistakes = mistakes;
    return true;
  }
} 