import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import 'sudoku_cell.dart';

class SudokuGrid extends StatelessWidget {
  const SudokuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the size of the grid to be square and fill the width
        final size = constraints.maxWidth;
        
        return AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 2.0,
              ),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
                childAspectRatio: 1.0,
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
    
    // Check if this cell should be highlighted (same row, column, or 3x3 box)
    final isHighlighted = isSelected || 
        (gameState.selectedRow != null && 
         (gameState.selectedRow == row || 
          gameState.selectedCol == col || 
          _isInSameBox(row, col, gameState.selectedRow!, gameState.selectedCol!)));
    
    // Check if this cell has an invalid value
    final isInvalid = value != null && !gameState.isValidMove(row, col, value);
    
    // Determine if this cell has a right or bottom border that should be thicker
    final isRightBorder = (col + 1) % 3 == 0 && col < 8;
    final isBottomBorder = (row + 1) % 3 == 0 && row < 8;
    
    return SudokuCell(
      value: value,
      isInitial: isInitial,
      isSelected: isSelected,
      isHighlighted: isHighlighted,
      isInvalid: isInvalid,
      isRightBorder: isRightBorder,
      isBottomBorder: isBottomBorder,
      onTap: () {
        gameState.selectCell(row, col);
      },
    );
  }
  
  bool _isInSameBox(int row1, int col1, int row2, int col2) {
    final boxRow1 = row1 ~/ 3;
    final boxCol1 = col1 ~/ 3;
    final boxRow2 = row2 ~/ 3;
    final boxCol2 = col2 ~/ 3;
    return boxRow1 == boxRow2 && boxCol1 == boxCol2;
  }
} 