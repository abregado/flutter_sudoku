import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import 'sudoku_cell.dart';

class SudokuGrid extends StatelessWidget {
  final bool showSolution;
  
  const SudokuGrid({
    super.key,
    this.showSolution = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: GridView.builder(
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
          ),
        );
      },
    );
  }

  Widget _buildCell(BuildContext context, int row, int col) {
    final gameState = context.watch<GameState>();
    final value = gameState.grid[row][col];
    final isInitial = gameState.initialCells[row][col];
    final isSelected = gameState.selectedRow == row && gameState.selectedCol == col;
    final isHighlighted = _isHighlighted(gameState, row, col);
    final isSameNumber = _hasSameNumber(gameState, row, col);
    final isInvalid = value != null && !gameState.isValidMove(row, col, value);
    
    return SudokuCell(
      value: value,
      solutionValue: showSolution ? gameState.solution[row][col] : null,
      isInitial: isInitial,
      isSelected: isSelected,
      isHighlighted: isHighlighted,
      isSameNumber: isSameNumber,
      isInvalid: isInvalid,
      showTopBorder: row % 3 == 0,
      showBottomBorder: row % 3 == 2,
      showLeftBorder: col % 3 == 0,
      showRightBorder: col % 3 == 2,
      onTap: () => gameState.selectCell(row, col),
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
} 