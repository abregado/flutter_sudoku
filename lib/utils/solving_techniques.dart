import 'dart:math';

class SolvingTechniques {
  static Set<int> getCandidates(List<List<int>> grid, int row, int col) {
    final candidates = <int>{};
    for (int num = 1; num <= 9; num++) {
      if (isSafe(grid, row, col, num)) {
        candidates.add(num);
      }
    }
    return candidates;
  }

  static bool isSafe(List<List<int>> grid, int row, int col, int num) {
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

  static bool applyNakedSingle(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    if (candidates.length == 1) {
      grid[row][col] = candidates.first;
      return true;
    }
    return false;
  }

  static bool applyHiddenSingle(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    for (final candidate in candidates) {
      if (isHiddenSingle(grid, row, col, candidate)) {
        grid[row][col] = candidate;
        return true;
      }
    }
    return false;
  }

  static bool isHiddenSingle(List<List<int>> grid, int row, int col, int num) {
    // Check row
    bool foundInRow = false;
    for (int j = 0; j < 9; j++) {
      if (j != col && getCandidates(grid, row, j).contains(num)) {
        foundInRow = true;
        break;
      }
    }
    if (!foundInRow) return true;
    
    // Check column
    bool foundInCol = false;
    for (int i = 0; i < 9; i++) {
      if (i != row && getCandidates(grid, i, col).contains(num)) {
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
        if ((i != row || j != col) && getCandidates(grid, i, j).contains(num)) {
          foundInBox = true;
          break;
        }
      }
      if (foundInBox) break;
    }
    if (!foundInBox) return true;
    
    return false;
  }

  static bool applyNakedPair(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    if (candidates.length != 2) return false;
    
    return _applyNakedSet(grid, row, col, candidates);
  }

  static bool applyNakedTriple(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    if (candidates.length != 3) return false;
    
    return _applyNakedSet(grid, row, col, candidates);
  }

  static bool _applyNakedSet(List<List<int>> grid, int row, int col, Set<int> set) {
    bool progress = false;
    
    // Check row
    for (int j = 0; j < 9; j++) {
      if (j != col && grid[row][j] == 0) {
        final candidates = getCandidates(grid, row, j);
        if (candidates.containsAll(set)) {
          candidates.removeAll(set);
          if (candidates.isEmpty) return false; // Invalid state
          progress = true;
        }
      }
    }
    
    // Check column
    for (int i = 0; i < 9; i++) {
      if (i != row && grid[i][col] == 0) {
        final candidates = getCandidates(grid, i, col);
        if (candidates.containsAll(set)) {
          candidates.removeAll(set);
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
          final candidates = getCandidates(grid, i, j);
          if (candidates.containsAll(set)) {
            candidates.removeAll(set);
            if (candidates.isEmpty) return false; // Invalid state
            progress = true;
          }
        }
      }
    }
    
    return progress;
  }

  static bool applyHiddenPair(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    if (candidates.length < 2) return false;
    
    return _applyHiddenSet(grid, row, col, candidates, 2);
  }

  static bool applyHiddenTriple(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    if (candidates.length < 3) return false;
    
    return _applyHiddenSet(grid, row, col, candidates, 3);
  }

  static bool _applyHiddenSet(List<List<int>> grid, int row, int col, Set<int> candidates, int setSize) {
    // Check row
    final rowCandidates = <int, Set<int>>{};
    for (int j = 0; j < 9; j++) {
      if (grid[row][j] == 0) {
        final cellCandidates = getCandidates(grid, row, j);
        for (final candidate in cellCandidates) {
          rowCandidates.putIfAbsent(candidate, () => <int>{});
          rowCandidates[candidate]!.add(j);
        }
      }
    }
    
    // Check column
    final colCandidates = <int, Set<int>>{};
    for (int i = 0; i < 9; i++) {
      if (grid[i][col] == 0) {
        final cellCandidates = getCandidates(grid, i, col);
        for (final candidate in cellCandidates) {
          colCandidates.putIfAbsent(candidate, () => <int>{});
          colCandidates[candidate]!.add(i);
        }
      }
    }
    
    // Check 3x3 box
    final boxCandidates = <int, Set<int>>{};
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = startRow; i < startRow + 3; i++) {
      for (int j = startCol; j < startCol + 3; j++) {
        if (grid[i][j] == 0) {
          final cellCandidates = getCandidates(grid, i, j);
          for (final candidate in cellCandidates) {
            boxCandidates.putIfAbsent(candidate, () => <int>{});
            boxCandidates[candidate]!.add(i * 9 + j);
          }
        }
      }
    }
    
    // Check for hidden sets
    bool progress = false;
    
    // Check row
    for (final candidate in candidates) {
      if (rowCandidates[candidate]?.length == setSize) {
        final set = rowCandidates[candidate]!;
        final setCandidates = <int>{};
        for (final j in set) {
          setCandidates.addAll(getCandidates(grid, row, j));
        }
        if (setCandidates.length == setSize) {
          for (final j in set) {
            if (j != col) {
              final cellCandidates = getCandidates(grid, row, j);
              cellCandidates.removeAll(setCandidates);
              if (cellCandidates.isEmpty) return false; // Invalid state
              progress = true;
            }
          }
        }
      }
    }
    
    // Check column
    for (final candidate in candidates) {
      if (colCandidates[candidate]?.length == setSize) {
        final set = colCandidates[candidate]!;
        final setCandidates = <int>{};
        for (final i in set) {
          setCandidates.addAll(getCandidates(grid, i, col));
        }
        if (setCandidates.length == setSize) {
          for (final i in set) {
            if (i != row) {
              final cellCandidates = getCandidates(grid, i, col);
              cellCandidates.removeAll(setCandidates);
              if (cellCandidates.isEmpty) return false; // Invalid state
              progress = true;
            }
          }
        }
      }
    }
    
    // Check 3x3 box
    for (final candidate in candidates) {
      if (boxCandidates[candidate]?.length == setSize) {
        final set = boxCandidates[candidate]!;
        final setCandidates = <int>{};
        for (final pos in set) {
          final i = pos ~/ 9;
          final j = pos % 9;
          setCandidates.addAll(getCandidates(grid, i, j));
        }
        if (setCandidates.length == setSize) {
          for (final pos in set) {
            final i = pos ~/ 9;
            final j = pos % 9;
            if (i != row || j != col) {
              final cellCandidates = getCandidates(grid, i, j);
              cellCandidates.removeAll(setCandidates);
              if (cellCandidates.isEmpty) return false; // Invalid state
              progress = true;
            }
          }
        }
      }
    }
    
    return progress;
  }

  static bool applyPointingPair(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    if (candidates.length < 2) return false;
    
    // Check if any candidate appears only in this row or column within the box
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    
    for (final candidate in candidates) {
      // Check row
      bool onlyInRow = true;
      for (int j = 0; j < 9; j++) {
        if (j < startCol || j >= startCol + 3) {
          if (getCandidates(grid, row, j).contains(candidate)) {
            onlyInRow = false;
            break;
          }
        }
      }
      
      if (onlyInRow) {
        // Remove candidate from other cells in the row
        bool progress = false;
        for (int j = 0; j < 9; j++) {
          if (j < startCol || j >= startCol + 3) {
            final cellCandidates = getCandidates(grid, row, j);
            if (cellCandidates.contains(candidate)) {
              cellCandidates.remove(candidate);
              if (cellCandidates.isEmpty) return false; // Invalid state
              progress = true;
            }
          }
        }
        if (progress) return true;
      }
      
      // Check column
      bool onlyInCol = true;
      for (int i = 0; i < 9; i++) {
        if (i < startRow || i >= startRow + 3) {
          if (getCandidates(grid, i, col).contains(candidate)) {
            onlyInCol = false;
            break;
          }
        }
      }
      
      if (onlyInCol) {
        // Remove candidate from other cells in the column
        bool progress = false;
        for (int i = 0; i < 9; i++) {
          if (i < startRow || i >= startRow + 3) {
            final cellCandidates = getCandidates(grid, i, col);
            if (cellCandidates.contains(candidate)) {
              cellCandidates.remove(candidate);
              if (cellCandidates.isEmpty) return false; // Invalid state
              progress = true;
            }
          }
        }
        if (progress) return true;
      }
    }
    
    return false;
  }

  static bool applyBoxLineReduction(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    if (candidates.isEmpty) return false;
    
    // Check if any candidate appears only in this box within the row or column
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    
    for (final candidate in candidates) {
      // Check row
      bool onlyInBox = true;
      for (int j = startCol; j < startCol + 3; j++) {
        if (j != col && getCandidates(grid, row, j).contains(candidate)) {
          onlyInBox = false;
          break;
        }
      }
      
      if (onlyInBox) {
        // Remove candidate from other cells in the box
        bool progress = false;
        for (int i = startRow; i < startRow + 3; i++) {
          for (int j = startCol; j < startCol + 3; j++) {
            if (i != row || j != col) {
              final cellCandidates = getCandidates(grid, i, j);
              if (cellCandidates.contains(candidate)) {
                cellCandidates.remove(candidate);
                if (cellCandidates.isEmpty) return false; // Invalid state
                progress = true;
              }
            }
          }
        }
        if (progress) return true;
      }
      
      // Check column
      onlyInBox = true;
      for (int i = startRow; i < startRow + 3; i++) {
        if (i != row && getCandidates(grid, i, col).contains(candidate)) {
          onlyInBox = false;
          break;
        }
      }
      
      if (onlyInBox) {
        // Remove candidate from other cells in the box
        bool progress = false;
        for (int i = startRow; i < startRow + 3; i++) {
          for (int j = startCol; j < startCol + 3; j++) {
            if (i != row || j != col) {
              final cellCandidates = getCandidates(grid, i, j);
              if (cellCandidates.contains(candidate)) {
                cellCandidates.remove(candidate);
                if (cellCandidates.isEmpty) return false; // Invalid state
                progress = true;
              }
            }
          }
        }
        if (progress) return true;
      }
    }
    
    return false;
  }

  static bool applyXWing(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    if (candidates.isEmpty) return false;
    
    // Try each candidate for X-Wing pattern
    for (final candidate in candidates) {
      // Find rows where this candidate appears exactly twice
      final rowPairs = <int, List<int>>{};
      for (int i = 0; i < 9; i++) {
        final positions = <int>[];
        for (int j = 0; j < 9; j++) {
          if (grid[i][j] == 0 && getCandidates(grid, i, j).contains(candidate)) {
            positions.add(j);
          }
        }
        if (positions.length == 2) {
          rowPairs[i] = positions;
        }
      }
      
      // Check for X-Wing pattern in rows
      if (rowPairs.length >= 2) {
        final rows = rowPairs.keys.toList();
        for (int i = 0; i < rows.length - 1; i++) {
          for (int j = i + 1; j < rows.length; j++) {
            final row1 = rows[i];
            final row2 = rows[j];
            if (rowPairs[row1]!.toSet() == rowPairs[row2]!.toSet()) {
              // Found X-Wing pattern, remove candidate from other cells in those columns
              bool progress = false;
              for (int r = 0; r < 9; r++) {
                if (r != row1 && r != row2) {
                  for (final c in rowPairs[row1]!) {
                    if (grid[r][c] == 0) {
                      final cellCandidates = getCandidates(grid, r, c);
                      if (cellCandidates.contains(candidate)) {
                        cellCandidates.remove(candidate);
                        if (cellCandidates.isEmpty) return false; // Invalid state
                        progress = true;
                      }
                    }
                  }
                }
              }
              if (progress) return true;
            }
          }
        }
      }
      
      // Find columns where this candidate appears exactly twice
      final colPairs = <int, List<int>>{};
      for (int j = 0; j < 9; j++) {
        final positions = <int>[];
        for (int i = 0; i < 9; i++) {
          if (grid[i][j] == 0 && getCandidates(grid, i, j).contains(candidate)) {
            positions.add(i);
          }
        }
        if (positions.length == 2) {
          colPairs[j] = positions;
        }
      }
      
      // Check for X-Wing pattern in columns
      if (colPairs.length >= 2) {
        final cols = colPairs.keys.toList();
        for (int i = 0; i < cols.length - 1; i++) {
          for (int j = i + 1; j < cols.length; j++) {
            final col1 = cols[i];
            final col2 = cols[j];
            if (colPairs[col1]!.toSet() == colPairs[col2]!.toSet()) {
              // Found X-Wing pattern, remove candidate from other cells in those rows
              bool progress = false;
              for (int c = 0; c < 9; c++) {
                if (c != col1 && c != col2) {
                  for (final r in colPairs[col1]!) {
                    if (grid[r][c] == 0) {
                      final cellCandidates = getCandidates(grid, r, c);
                      if (cellCandidates.contains(candidate)) {
                        cellCandidates.remove(candidate);
                        if (cellCandidates.isEmpty) return false; // Invalid state
                        progress = true;
                      }
                    }
                  }
                }
              }
              if (progress) return true;
            }
          }
        }
      }
    }
    
    return false;
  }

  static bool applyYWing(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return false;
    
    final candidates = getCandidates(grid, row, col);
    if (candidates.length != 2) return false;
    
    // Try each candidate as the pivot
    for (final pivot in candidates) {
      // Find cells that share a unit with this cell and have exactly two candidates
      final neighbors = <int, Set<int>>{};
      
      // Check row
      for (int j = 0; j < 9; j++) {
        if (j != col && grid[row][j] == 0) {
          final cellCandidates = getCandidates(grid, row, j);
          if (cellCandidates.length == 2) {
            neighbors[row * 9 + j] = cellCandidates;
          }
        }
      }
      
      // Check column
      for (int i = 0; i < 9; i++) {
        if (i != row && grid[i][col] == 0) {
          final cellCandidates = getCandidates(grid, i, col);
          if (cellCandidates.length == 2) {
            neighbors[i * 9 + col] = cellCandidates;
          }
        }
      }
      
      // Check 3x3 box
      int startRow = row - row % 3;
      int startCol = col - col % 3;
      for (int i = startRow; i < startRow + 3; i++) {
        for (int j = startCol; j < startCol + 3; j++) {
          if ((i != row || j != col) && grid[i][j] == 0) {
            final cellCandidates = getCandidates(grid, i, j);
            if (cellCandidates.length == 2) {
              neighbors[i * 9 + j] = cellCandidates;
            }
          }
        }
      }
      
      // Look for Y-Wing pattern
      for (final entry1 in neighbors.entries) {
        final pos1 = entry1.key;
        final candidates1 = entry1.value;
        
        for (final entry2 in neighbors.entries) {
          final pos2 = entry2.key;
          final candidates2 = entry2.value;
          
          if (pos1 != pos2) {
            // Check if these cells form a Y-Wing with the pivot
            final commonCandidates = candidates1.intersection(candidates2);
            if (commonCandidates.length == 1) {
              final commonCandidate = commonCandidates.first;
              
              // Find cells that see both wings
              bool progress = false;
              for (int i = 0; i < 9; i++) {
                for (int j = 0; j < 9; j++) {
                  if (grid[i][j] == 0) {
                    final cellCandidates = getCandidates(grid, i, j);
                    if (cellCandidates.contains(commonCandidate)) {
                      // Check if this cell sees both wings
                      final row1 = pos1 ~/ 9;
                      final col1 = pos1 % 9;
                      final row2 = pos2 ~/ 9;
                      final col2 = pos2 % 9;
                      
                      bool seesWing1 = (i == row1 || j == col1 || 
                          (i ~/ 3 == row1 ~/ 3 && j ~/ 3 == col1 ~/ 3));
                      bool seesWing2 = (i == row2 || j == col2 || 
                          (i ~/ 3 == row2 ~/ 3 && j ~/ 3 == col2 ~/ 3));
                      
                      if (seesWing1 && seesWing2) {
                        cellCandidates.remove(commonCandidate);
                        if (cellCandidates.isEmpty) return false; // Invalid state
                        progress = true;
                      }
                    }
                  }
                }
              }
              if (progress) return true;
            }
          }
        }
      }
    }
    
    return false;
  }
} 