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
    
    // Remove numbers while maintaining solvability
    _removeNumbersWhileMaintainingSolvability(grid, solution);
    
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
  
  void _removeNumbersWhileMaintainingSolvability(List<List<int>> grid, List<List<int>> solution) {
    // Create a list of all positions
    final positions = List.generate(81, (i) => i)..shuffle(_random);
    
    // Try to remove each number
    for (final pos in positions) {
      final row = pos ~/ 9;
      final col = pos % 9;
      final originalValue = grid[row][col];
      
      // Skip if already removed
      if (originalValue == 0) continue;
      
      // Try removing the number
      grid[row][col] = 0;
      
      // Check if the puzzle is still solvable using basic techniques
      if (!_isSolvableWithBasicTechniques(grid, solution)) {
        // If not solvable, restore the number
        grid[row][col] = originalValue;
      }
    }
  }
  
  bool _isSolvableWithBasicTechniques(List<List<int>> grid, List<List<int>> solution) {
    // Create a copy of the grid to work with
    final workingGrid = List.generate(9, (i) => List<int>.from(grid[i]));
    
    // Keep applying basic techniques until no more progress can be made
    bool progress;
    int iterations = 0;
    const maxIterations = 100; // Prevent infinite loops
    
    do {
      progress = false;
      iterations++;
      
      // Try naked singles
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (workingGrid[i][j] == 0) {
            final candidates = _getCandidates(workingGrid, i, j);
            if (candidates.length == 1) {
              workingGrid[i][j] = candidates.first;
              progress = true;
            }
          }
        }
      }
      
      // Try hidden singles
      if (!progress) {
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            if (workingGrid[i][j] == 0) {
              final candidates = _getCandidates(workingGrid, i, j);
              for (final candidate in candidates) {
                if (_isHiddenSingle(workingGrid, i, j, candidate)) {
                  workingGrid[i][j] = candidate;
                  progress = true;
                  break;
                }
              }
            }
          }
        }
      }
      
      // Try naked pairs
      if (!progress) {
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            if (workingGrid[i][j] == 0) {
              final candidates = _getCandidates(workingGrid, i, j);
              if (candidates.length == 2) {
                // Check if this pair can be used to eliminate candidates
                if (_applyNakedPair(workingGrid, i, j, candidates)) {
                  progress = true;
                }
              }
            }
          }
        }
      }
    } while (progress && iterations < maxIterations);
    
    // If we hit the iteration limit, consider it not solvable
    if (iterations >= maxIterations) return false;
    
    // Check if the puzzle is solved
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (workingGrid[i][j] == 0) return false;
      }
    }
    
    // Verify the solution matches
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (workingGrid[i][j] != solution[i][j]) return false;
      }
    }
    
    return true;
  }
  
  Set<int> _getCandidates(List<List<int>> grid, int row, int col) {
    final candidates = <int>{};
    for (int num = 1; num <= 9; num++) {
      if (_isSafe(grid, row, col, num)) {
        candidates.add(num);
      }
    }
    return candidates;
  }
  
  bool _isHiddenSingle(List<List<int>> grid, int row, int col, int num) {
    // Check row
    bool foundInRow = false;
    for (int j = 0; j < 9; j++) {
      if (j != col && _getCandidates(grid, row, j).contains(num)) {
        foundInRow = true;
        break;
      }
    }
    if (!foundInRow) return true;
    
    // Check column
    bool foundInCol = false;
    for (int i = 0; i < 9; i++) {
      if (i != row && _getCandidates(grid, i, col).contains(num)) {
        foundInCol = true;
        break;
      }
    }
    if (!foundInCol) return true;
    
    // Check 3x3 box
    bool foundInBox = false;
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = startRow; i < startRow + 3; i++) {
      for (int j = startCol; j < startCol + 3; j++) {
        if ((i != row || j != col) && _getCandidates(grid, i, j).contains(num)) {
          foundInBox = true;
          break;
        }
      }
      if (foundInBox) break;
    }
    if (!foundInBox) return true;
    
    return false;
  }
  
  bool _applyNakedPair(List<List<int>> grid, int row, int col, Set<int> pair) {
    bool progress = false;
    
    // Check row
    for (int j = 0; j < 9; j++) {
      if (j != col && grid[row][j] == 0) {
        final candidates = _getCandidates(grid, row, j);
        if (candidates.containsAll(pair)) {
          candidates.removeAll(pair);
          if (candidates.isEmpty) return false; // Invalid state
          progress = true;
        }
      }
    }
    
    // Check column
    for (int i = 0; i < 9; i++) {
      if (i != row && grid[i][col] == 0) {
        final candidates = _getCandidates(grid, i, col);
        if (candidates.containsAll(pair)) {
          candidates.removeAll(pair);
          if (candidates.isEmpty) return false; // Invalid state
          progress = true;
        }
      }
    }
    
    // Check 3x3 box
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = startRow; i < startRow + 3; i++) {
      for (int j = startCol; j < startCol + 3; j++) {
        if ((i != row || j != col) && grid[i][j] == 0) {
          final candidates = _getCandidates(grid, i, j);
          if (candidates.containsAll(pair)) {
            candidates.removeAll(pair);
            if (candidates.isEmpty) return false; // Invalid state
            progress = true;
          }
        }
      }
    }
    
    return progress;
  }
} 