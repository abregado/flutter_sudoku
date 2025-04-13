class SudokuGenerator {
  static final Random _random = Random();
  
  static List<List<int>> generatePuzzle() {
    // Generate a complete solution
    final solution = _generateSolution();
    
    // Create a copy of the solution to work with
    final puzzle = List<List<int>>.generate(9, (i) => List<int>.from(solution[i]));
    
    // Remove numbers while ensuring unique solution
    _removeNumbers(puzzle, solution);
    
    return puzzle;
  }
  
  static List<List<int>> _generateSolution() {
    final grid = List<List<int>>.generate(9, (_) => List.filled(9, 0));
    _fillGrid(grid);
    return grid;
  }
  
  static bool _fillGrid(List<List<int>> grid) {
    final empty = _findEmpty(grid);
    if (empty == null) return true;
    
    final row = empty[0];
    final col = empty[1];
    
    // Try numbers 1-9 in random order
    final numbers = List.generate(9, (i) => i + 1)..shuffle(_random);
    
    for (final num in numbers) {
      if (_isValid(grid, row, col, num)) {
        grid[row][col] = num;
        if (_fillGrid(grid)) return true;
        grid[row][col] = 0;
      }
    }
    
    return false;
  }
  
  static List<int>? _findEmpty(List<List<int>> grid) {
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        if (grid[i][j] == 0) return [i, j];
      }
    }
    return null;
  }
  
  static bool _isValid(List<List<int>> grid, int row, int col, int num) {
    // Check row
    for (var x = 0; x < 9; x++) {
      if (grid[row][x] == num) return false;
    }
    
    // Check column
    for (var x = 0; x < 9; x++) {
      if (grid[x][col] == num) return false;
    }
    
    // Check 3x3 box
    final startRow = row - row % 3;
    final startCol = col - col % 3;
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (grid[startRow + i][startCol + j] == num) return false;
      }
    }
    
    return true;
  }
  
  static void _removeNumbers(List<List<int>> puzzle, List<List<int>> solution) {
    // Create a list of all positions
    final positions = List.generate(81, (i) => [i ~/ 9, i % 9])..shuffle(_random);
    
    // Keep track of cells we've successfully removed
    final removedCells = <List<int>>[];
    
    // Try removing each position
    for (final pos in positions) {
      final row = pos[0];
      final col = pos[1];
      final temp = puzzle[row][col];
      puzzle[row][col] = 0;
      
      // Check if the puzzle still has a unique solution
      if (_hasUniqueSolution(puzzle, solution)) {
        removedCells.add([row, col]);
      } else {
        // If removing this number creates multiple solutions, put it back
        puzzle[row][col] = temp;
      }
      
      // Periodically verify the overall puzzle still has a unique solution
      if (removedCells.length % 5 == 0 && removedCells.isNotEmpty) {
        // Create a test puzzle copy
        final testPuzzle = List<List<int>>.generate(
          9, 
          (i) => List<int>.from(puzzle[i])
        );
        
        // If the puzzle no longer has a unique solution, restore the last few removed cells
        if (!_hasUniqueSolution(testPuzzle, solution)) {
          for (var i = 0; i < 5 && removedCells.isNotEmpty; i++) {
            final lastRemoved = removedCells.removeLast();
            puzzle[lastRemoved[0]][lastRemoved[1]] = solution[lastRemoved[0]][lastRemoved[1]];
          }
          break;
        }
      }
    }
  }
  
  static bool _hasUniqueSolution(List<List<int>> puzzle, List<List<int>> solution) {
    var solutions = 0;
    final puzzleCopy = List<List<int>>.generate(
      9, 
      (i) => List<int>.from(puzzle[i])
    );
    
    _countSolutions(puzzleCopy, solution, 0, 0, (solved) {
      if (solved) solutions++;
      return solutions <= 1; // Stop if we find more than one solution
    });
    return solutions == 1;
  }
  
  static bool _countSolutions(
    List<List<int>> puzzle,
    List<List<int>> solution,
    int row,
    int col,
    Function(bool) onSolution,
  ) {
    if (row == 9) {
      onSolution(true);
      return true;
    }
    
    if (col == 9) {
      return _countSolutions(puzzle, solution, row + 1, 0, onSolution);
    }
    
    if (puzzle[row][col] != 0) {
      return _countSolutions(puzzle, solution, row, col + 1, onSolution);
    }
    
    for (var num = 1; num <= 9; num++) {
      if (_isValid(puzzle, row, col, num)) {
        puzzle[row][col] = num;
        if (!_countSolutions(puzzle, solution, row, col + 1, onSolution)) {
          return false;
        }
        puzzle[row][col] = 0;
      }
    }
    
    return true;
  }
} 