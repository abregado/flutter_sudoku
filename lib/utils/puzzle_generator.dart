import 'dart:math';
import 'dart:async';
import 'dart:isolate';
import '../models/puzzle_settings.dart';
import 'solving_techniques.dart';

abstract class PuzzleGenerator {
  /// Generates a new Sudoku puzzle based on the given settings
  /// Returns a tuple of (grid, solution) where grid is the initial state
  /// and solution is the complete solution
  (List<List<int?>>, List<List<int>>) generatePuzzle(PuzzleSettings settings);
  
  /// Asynchronously generates a new Sudoku puzzle
  /// Returns a Future that completes with a tuple of (grid, solution)
  Future<(List<List<int?>>, List<List<int>>)> generatePuzzleAsync(
    PuzzleSettings settings,
    void Function(double) onProgress,
  );
}

class BacktrackingGenerator implements PuzzleGenerator {
  final Random _random = Random();
  bool _isGenerating = false;
  
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
  
  @override
  Future<(List<List<int?>>, List<List<int>>)> generatePuzzleAsync(
    PuzzleSettings settings,
    void Function(double) onProgress,
  ) async {
    if (_isGenerating) {
      throw StateError('Puzzle generation already in progress');
    }
    
    _isGenerating = true;
    
    try {
      // Create a receive port for the isolate
      final receivePort = ReceivePort();
      
      // Create the isolate
      final isolate = await Isolate.spawn(
        (SendPort sendPort) async {
          final random = Random();
          
          // Generate a complete solution first
          final solution = _generateSolutionInIsolate(random);
          
          // Create a copy of the solution to remove numbers from
          final grid = List.generate(9, (i) => List.generate(9, (j) => solution[i][j]));
          
          // Remove numbers while maintaining solvability
          await _removeNumbersWhileMaintainingSolvabilityInIsolate(grid, solution, random, sendPort);
          
          // Convert to nullable grid for the game state
          final nullableGrid = List.generate(9, (i) => 
            List.generate(9, (j) => grid[i][j] == 0 ? null : grid[i][j]));
          
          sendPort.send((nullableGrid, solution));
        },
        receivePort.sendPort,
      );
      
      // Listen for progress updates and the final result
      final completer = Completer<(List<List<int?>>, List<List<int>>)>();
      
      receivePort.listen((message) {
        if (message is double) {
          // Progress update
          onProgress(message);
        } else {
          // Final result
          completer.complete(message as (List<List<int?>>, List<List<int>>));
          receivePort.close();
          isolate.kill();
        }
      });
      
      return await completer.future;
    } finally {
      _isGenerating = false;
    }
  }
  
  List<List<int>> _generateSolution() {
    final grid = List.generate(9, (_) => List.filled(9, 0));
    _solveSudoku(grid);
    return grid;
  }
  
  static List<List<int>> _generateSolutionInIsolate(Random random) {
    final grid = List.generate(9, (_) => List.filled(9, 0));
    _solveSudokuInIsolate(grid, random);
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
      if (SolvingTechniques.isSafe(grid, row, col, num)) {
        grid[row][col] = num;
        
        if (_solveSudoku(grid)) return true;
        
        grid[row][col] = 0;
      }
    }
    
    return false;
  }
  
  static bool _solveSudokuInIsolate(List<List<int>> grid, Random random) {
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
    final numbers = List.generate(9, (i) => i + 1)..shuffle(random);
    for (final num in numbers) {
      if (SolvingTechniques.isSafe(grid, row, col, num)) {
        grid[row][col] = num;
        
        if (_solveSudokuInIsolate(grid, random)) return true;
        
        grid[row][col] = 0;
      }
    }
    
    return false;
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
  
  static Future<void> _removeNumbersWhileMaintainingSolvabilityInIsolate(
    List<List<int>> grid,
    List<List<int>> solution,
    Random random,
    SendPort sendPort,
  ) async {
    // Create a list of all positions
    final positions = List.generate(81, (i) => i)..shuffle(random);
    
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
      if (!_isSolvableWithBasicTechniquesInIsolate(grid, solution)) {
        // If not solvable, restore the number
        grid[row][col] = originalValue;
      }
      
      // Send progress update every 200 positions
      if (pos % 200 == 0) {
        sendPort.send(pos / 81); // Send progress as a fraction between 0 and 1
      }
    }
  }
  
  bool _isSolvableWithBasicTechniques(List<List<int>> grid, List<List<int>> solution) {
    // Create a copy of the grid to work with
    final workingGrid = List.generate(9, (i) => List<int>.from(grid[i]));
    
    // Keep applying basic techniques until no more progress can be made
    bool progress;
    int iterations = 0;
    const maxIterations = 500; // Prevent infinite loops
    
    do {
      progress = false;
      iterations++;
      
      // Try each technique in order of complexity
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (workingGrid[i][j] == 0) {
            // Try Box Line Reduction
            if (SolvingTechniques.applyBoxLineReduction(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try pointing pair
            if (SolvingTechniques.applyPointingPair(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try hidden triple
            if (SolvingTechniques.applyHiddenTriple(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try hidden pair
            if (SolvingTechniques.applyHiddenPair(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try naked pair
            if (SolvingTechniques.applyNakedPair(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try hidden single
            if (SolvingTechniques.applyHiddenSingle(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try naked single
            if (SolvingTechniques.applyNakedSingle(workingGrid, i, j)) {
              progress = true;
              continue;
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
  
  static bool _isSolvableWithBasicTechniquesInIsolate(List<List<int>> grid, List<List<int>> solution) {
    // Create a copy of the grid to work with
    final workingGrid = List.generate(9, (i) => List<int>.from(grid[i]));
    
    // Keep applying basic techniques until no more progress can be made
    bool progress;
    int iterations = 0;
    const maxIterations = 500; // Prevent infinite loops
    
    do {
      progress = false;
      iterations++;
      
      // Try each technique in order of complexity
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          if (workingGrid[i][j] == 0) {
            // Try pointing pair
            if (SolvingTechniques.applyPointingPair(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try hidden triple
            if (SolvingTechniques.applyHiddenTriple(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try hidden pair
            if (SolvingTechniques.applyHiddenPair(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try naked pair
            if (SolvingTechniques.applyNakedPair(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try hidden single
            if (SolvingTechniques.applyHiddenSingle(workingGrid, i, j)) {
              progress = true;
              continue;
            }
            
            // Try naked single
            if (SolvingTechniques.applyNakedSingle(workingGrid, i, j)) {
              progress = true;
              continue;
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
} 