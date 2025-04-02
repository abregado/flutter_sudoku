import 'dart:math';
import '../models/puzzle_settings.dart';

abstract class PuzzleGenerator {
  /// Generates a new Sudoku puzzle based on the given settings
  /// Returns a tuple of (grid, solution) where grid is the initial state
  /// and solution is the complete solution
  (List<List<int?>>, List<List<int>>) generatePuzzle(PuzzleSettings settings);
}

class BacktrackingGenerator implements PuzzleGenerator {
  final Random _random = Random();
  
  @override
  (List<List<int?>>, List<List<int>>) generatePuzzle(PuzzleSettings settings) {
    // Generate a complete solution first
    final solution = _generateSolution();
    
    // Create a copy of the solution to remove numbers from
    final grid = List.generate(9, (i) => List.generate(9, (j) => solution[i][j]));
    
    // Remove numbers based on difficulty
    _removeNumbers(grid, settings.cellsToRemove);
    
    // Convert to nullable grid for the game state
    final nullableGrid = List.generate(9, (i) => 
      List.generate(9, (j) => grid[i][j] == 0 ? null : grid[i][j]));
    
    return (nullableGrid, solution);
  }
  
  List<List<int>> _generateSolution() {
    final grid = List.generate(9, (_) => List.filled(9, 0));
    _solveSudoku(grid);
    return grid;
  }
  
  bool _solveSudoku(List<List<int>> grid) {
    // Find empty cell
    int? row, col;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] == 0) {
          row = i;
          col = j;
          break;
        }
      }
      if (row != null) break;
    }
    
    // If no empty cell is found, puzzle is solved
    if (row == null || col == null) return true;
    
    // Try numbers 1-9 in random order
    final numbers = List.generate(9, (i) => i + 1)..shuffle(_random);
    for (final num in numbers) {
      if (_isSafe(grid, row, col, num)) {
        grid[row][col] = num;
        
        if (_solveSudoku(grid)) return true;
        
        grid[row][col] = 0;
      }
    }
    
    return false;
  }
  
  bool _isSafe(List<List<int>> grid, int row, int col, int num) {
    // Check row
    for (int x = 0; x < 9; x++) {
      if (grid[row][x] == num) return false;
    }
    
    // Check column
    for (int x = 0; x < 9; x++) {
      if (grid[x][col] == num) return false;
    }
    
    // Check 3x3 box
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i + startRow][j + startCol] == num) return false;
      }
    }
    
    return true;
  }
  
  void _removeNumbers(List<List<int>> grid, int count) {
    final positions = List.generate(81, (i) => i)..shuffle(_random);
    
    for (int i = 0; i < count && i < positions.length; i++) {
      final pos = positions[i];
      final row = pos ~/ 9;
      final col = pos % 9;
      grid[row][col] = 0;
    }
  }
} 