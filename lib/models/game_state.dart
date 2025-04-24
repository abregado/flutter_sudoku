import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameState extends ChangeNotifier {
  static const String _storageKey = 'game_state';
  static const String _nextPuzzleKey = 'next_puzzle';
  
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
  
  // Next puzzle storage
  List<List<int?>>? _nextGrid;
  List<List<int>>? _nextSolution;
  bool _isGeneratingNextPuzzle = false;
  
  Duration get elapsedTime => _elapsedTime;
  bool get showTimer => _showTimer;
  Duration? get completionTime => _completionTime;
  int get completionMistakes => _completionMistakes;
  bool get isGeneratingNextPuzzle => _isGeneratingNextPuzzle;
  
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
    _nextGrid = other._nextGrid != null 
        ? List.generate(9, (i) => List.from(other._nextGrid![i]))
        : null;
    _nextSolution = other._nextSolution != null
        ? List.generate(9, (i) => List.from(other._nextSolution![i]))
        : null;
    _isGeneratingNextPuzzle = other._isGeneratingNextPuzzle;
  }
  
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = prefs.getString(_storageKey);
    final nextPuzzleJson = prefs.getString(_nextPuzzleKey);
    
    if (stateJson != null) {
      final state = jsonDecode(stateJson) as Map<String, dynamic>;
      grid = _parseGrid(state['grid'] as List);
      solution = _parseSolution(state['solution'] as List);
      initialCells = _parseInitialCells(state['initialCells'] as List);
      mistakes = state['mistakes'] as int;
      _elapsedTime = Duration(seconds: state['elapsedTime'] as int);
      _showTimer = state['showTimer'] as bool;
      _completionTime = state['completionTime'] != null 
          ? Duration(seconds: state['completionTime'] as int)
          : null;
      _completionMistakes = state['completionMistakes'] as int;
    }
    
    if (nextPuzzleJson != null) {
      final nextPuzzle = jsonDecode(nextPuzzleJson) as Map<String, dynamic>;
      _nextGrid = _parseGrid(nextPuzzle['grid'] as List);
      _nextSolution = _parseSolution(nextPuzzle['solution'] as List);
    }
    
    notifyListeners();
  }
  
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    final state = {
      'grid': _serializeGrid(grid),
      'solution': _serializeSolution(solution),
      'initialCells': _serializeInitialCells(initialCells),
      'mistakes': mistakes,
      'elapsedTime': _elapsedTime.inSeconds,
      'showTimer': _showTimer,
      'completionTime': _completionTime?.inSeconds,
      'completionMistakes': _completionMistakes,
    };
    
    await prefs.setString(_storageKey, jsonEncode(state));
    
    if (_nextGrid != null && _nextSolution != null) {
      final nextPuzzle = {
        'grid': _serializeGrid(_nextGrid!),
        'solution': _serializeSolution(_nextSolution!),
      };
      await prefs.setString(_nextPuzzleKey, jsonEncode(nextPuzzle));
    }
  }
  
  List<List<int?>> _parseGrid(List gridJson) {
    return List.generate(9, (i) => 
      List.generate(9, (j) => gridJson[i][j] as int?));
  }
  
  List<List<int>> _parseSolution(List solutionJson) {
    return List.generate(9, (i) => 
      List.generate(9, (j) => solutionJson[i][j] as int));
  }
  
  List<List<bool>> _parseInitialCells(List initialCellsJson) {
    return List.generate(9, (i) => 
      List.generate(9, (j) => initialCellsJson[i][j] as bool));
  }
  
  List<List<dynamic>> _serializeGrid(List<List<int?>> grid) {
    return List.generate(9, (i) => 
      List.generate(9, (j) => grid[i][j]));
  }
  
  List<List<dynamic>> _serializeSolution(List<List<int>> solution) {
    return List.generate(9, (i) => 
      List.generate(9, (j) => solution[i][j]));
  }
  
  List<List<dynamic>> _serializeInitialCells(List<List<bool>> initialCells) {
    return List.generate(9, (i) => 
      List.generate(9, (j) => initialCells[i][j]));
  }
  
  void startGeneratingNextPuzzle() {
    if (_isGeneratingNextPuzzle) return;
    _isGeneratingNextPuzzle = true;
    notifyListeners();
  }
  
  void setNextPuzzle(List<List<int?>> grid, List<List<int>> solution) {
    _nextGrid = grid;
    _nextSolution = solution;
    _isGeneratingNextPuzzle = false;
    _saveState();
    notifyListeners();
  }
  
  bool hasNextPuzzle() {
    return _nextGrid != null && _nextSolution != null;
  }
  
  void useNextPuzzle() {
    if (!hasNextPuzzle()) return;
    
    grid = _nextGrid!;
    solution = _nextSolution!;
    initialCells = List.generate(9, (i) => 
      List.generate(9, (j) => grid[i][j] != null));
    selectedRow = null;
    selectedCol = null;
    mistakes = 0;
    startTime = DateTime.now();
    undoStack.clear();
    _nextGrid = null;
    _nextSolution = null;
    
    _saveState();
    notifyListeners();
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
    stopTimer(); // Stop the timer when puzzle is complete
    return true;
  }
} 