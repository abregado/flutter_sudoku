import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../providers/theme_provider.dart';
import 'sudoku_cell.dart';

class SudokuGrid extends StatelessWidget {
  final bool showSolution;
  final bool isPreview;
  final List<List<bool>>? previewInitialCells;
  
  const SudokuGrid({
    super.key,
    this.showSolution = false,
    this.isPreview = false,
    this.previewInitialCells,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            physics: isPreview ? const NeverScrollableScrollPhysics() : null,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
              childAspectRatio: 1,
            ),
            itemCount: 81,
            itemBuilder: (context, index) {
              final row = index ~/ 9;
              final col = index % 9;
              return _buildCell(context, row, col);
            },
          ),
        );
      },
    );
  }

  Widget _buildCell(BuildContext context, int row, int col) {
    final gameState = context.watch<GameState>();
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    final value = isPreview 
        ? ((row * 3 + row ~/ 3 + col) % 9 + 1) 
        : gameState.grid[row][col];
    final isInitial = isPreview 
        ? (previewInitialCells?[row][col] ?? true)
        : gameState.initialCells[row][col];
    final isSelected = isPreview 
        ? (row == 4 && col == 4)
        : (gameState.selectedRow == row && gameState.selectedCol == col);
    final isHighlighted = isPreview 
        ? _isHighlightedPreview(row, col) 
        : _isHighlighted(gameState, row, col);
    final isSameNumber = isPreview 
        ? _hasSameNumberPreview(row, col) 
        : _hasSameNumber(gameState, row, col);
    final isInvalid = isPreview 
        ? false 
        : (value != null && !gameState.isValidMove(row, col, value));
    final solutionValue = isPreview 
        ? null 
        : (showSolution ? gameState.solution[row][col] : null);
    
    return SudokuCell(
      value: value,
      solutionValue: solutionValue,
      isInitial: isInitial,
      isSelected: isSelected,
      isHighlighted: isHighlighted,
      isSameNumber: isSameNumber,
      isInvalid: isInvalid,
      showTopBorder: row % 3 == 0,
      showBottomBorder: row % 3 == 2,
      showLeftBorder: col % 3 == 0,
      showRightBorder: col % 3 == 2,
      borderThickness: currentTheme.gridSquareBorderThickness,
      onTap: isPreview ? null : () => gameState.selectCell(row, col),
    );
  }
  
  bool _isInSameBox(int row1, int col1, int row2, int col2) {
    final boxRow1 = row1 ~/ 3;
    final boxCol1 = col1 ~/ 3;
    final boxRow2 = row2 ~/ 3;
    final boxCol2 = col2 ~/ 3;
    return boxRow1 == boxRow2 && boxCol1 == boxCol2;
  }

  bool _hasSameNumber(GameState gameState, int row, int col) {
    if (gameState.selectedRow == null || gameState.selectedCol == null) {
      return false;
    }
    
    final selectedValue = gameState.grid[gameState.selectedRow!][gameState.selectedCol!];
    final currentValue = gameState.grid[row][col];
    
    return selectedValue != null && 
           currentValue != null && 
           selectedValue == currentValue &&
           !(row == gameState.selectedRow! && col == gameState.selectedCol!);
  }

  bool _hasSameNumberPreview(int row, int col) {
    const selectedRow = 4;
    const selectedCol = 4;
    final selectedValue = ((selectedRow * 3 + selectedRow ~/ 3 + selectedCol) % 9 + 1);
    final currentValue = ((row * 3 + row ~/ 3 + col) % 9 + 1);
    
    return selectedValue == currentValue && !(row == selectedRow && col == selectedCol);
  }

  bool _isHighlighted(GameState gameState, int row, int col) {
    if (gameState.selectedRow == null || gameState.selectedCol == null) {
      return false;
    }

    final isSelected = gameState.selectedRow == row && gameState.selectedCol == col;
    
    // Check if this cell should be highlighted (same row, column, or 3x3 box)
    final isHighlighted = isSelected || 
        (gameState.selectedRow == row || 
         gameState.selectedCol == col || 
         _isInSameBox(row, col, gameState.selectedRow!, gameState.selectedCol!));
    
    return isHighlighted;
  }

  bool _isHighlightedPreview(int row, int col) {
    const selectedRow = 4;
    const selectedCol = 4;
    
    final isSelected = row == selectedRow && col == selectedCol;
    
    // Check if this cell should be highlighted (same row, column, or 3x3 box)
    final isHighlighted = isSelected || 
        (selectedRow == row || 
         selectedCol == col || 
         _isInSameBox(row, col, selectedRow, selectedCol));
    
    return isHighlighted;
  }
} 