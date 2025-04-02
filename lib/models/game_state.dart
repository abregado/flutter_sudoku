import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
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
  void makeMove(int row, int col, int? value) {
    if (initialCells[row][col]) return; // Can't modify initial cells
    
    // Save current state for undo
    undoStack.add(GameState.from(this));
    
    // Make the move
    grid[row][col] = value;
    
    // Check if move is valid (only if we're setting a value, not clearing)
    if (value != null && !isValidMove(row, col, value)) {
      mistakes++;
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
    if (undoStack.isEmpty) return;
    
    GameState previousState = undoStack.removeLast();
    grid = previousState.grid;
    mistakes = previousState.mistakes;
    
    notifyListeners();
  }
  
  // Start new game with generated puzzle
  void startNewGameWithPuzzle(List<List<int?>> newGrid, List<List<int>> newSolution) {
    grid = newGrid;
    solution = newSolution;
    
    // Mark initial cells
    initialCells = List.generate(9, (i) => 
      List.generate(9, (j) => grid[i][j] != null));
    
    selectedRow = null;
    selectedCol = null;
    mistakes = 0;
    startTime = DateTime.now();
    undoStack.clear();
    
    notifyListeners();
  }
  
  // Start new game (empty grid)
  void startNewGame() {
    grid = List.generate(9, (_) => List.filled(9, null));
    solution = List.generate(9, (_) => List.filled(9, 0));
    initialCells = List.generate(9, (_) => List.filled(9, false));
    selectedRow = null;
    selectedCol = null;
    mistakes = 0;
    startTime = DateTime.now();
    undoStack.clear();
    
    notifyListeners();
  }
  
  // Check if game is complete
  bool isComplete() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] == null) return false;
      }
    }
    return true;
  }
  
  // Constructor
  GameState();
  
  // Copy constructor
  GameState.from(GameState other) {
    grid = List.generate(9, (i) => List.from(other.grid[i]));
    solution = List.generate(9, (i) => List.from(other.solution[i]));
    initialCells = List.generate(9, (i) => List.from(other.initialCells[i]));
    selectedRow = other.selectedRow;
    selectedCol = other.selectedCol;
    mistakes = other.mistakes;
    startTime = other.startTime;
  }
} 