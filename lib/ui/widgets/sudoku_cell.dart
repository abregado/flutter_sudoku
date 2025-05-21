import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/puzzle_settings.dart';
import '../../providers/theme_provider.dart';
import '../../models/game_state.dart';

class SudokuCell extends StatelessWidget {
  final int? value;
  final int? solutionValue;
  final bool isInitial;
  final bool isSelected;
  final bool isHighlighted;
  final bool isSameNumber;
  final bool isInvalid;
  final bool showTopBorder;
  final bool showBottomBorder;
  final bool showLeftBorder;
  final bool showRightBorder;
  final double borderThickness;
  final VoidCallback? onTap;
  final bool showPairs;
  final bool showSingles;
  final bool showTriples;
  final int cellRow;
  final int cellCol;

  const SudokuCell({
    super.key,
    required this.value,
    this.solutionValue,
    required this.isInitial,
    required this.isSelected,
    required this.isHighlighted,
    this.isSameNumber = false,
    required this.isInvalid,
    required this.showTopBorder,
    required this.showBottomBorder,
    required this.showLeftBorder,
    required this.showRightBorder,
    required this.borderThickness,
    required this.onTap,
    this.showPairs = false,
    this.showSingles = false,
    this.showTriples = false,
    required this.cellRow,
    required this.cellCol,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    final gameState = context.watch<GameState>();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          border: Border(
            top: BorderSide(
              color: currentTheme.gridLineColor,
              width: showTopBorder ? borderThickness * 2 : borderThickness,
            ),
            bottom: BorderSide(
              color: currentTheme.gridLineColor,
              width: showBottomBorder ? borderThickness * 2 : borderThickness,
            ),
            left: BorderSide(
              color: currentTheme.gridLineColor,
              width: showLeftBorder ? borderThickness * 2 : borderThickness,
            ),
            right: BorderSide(
              color: currentTheme.gridLineColor,
              width: showRightBorder ? borderThickness * 2 : borderThickness,
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (solutionValue != null && value == null)
              Text(
                solutionValue.toString(),
                style: TextStyle(
                  fontSize: 24,
                  color: _getTextColor(context),
                ),
              ),
            if (value != null)
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: isInitial ? FontWeight.bold : FontWeight.normal,
                  fontStyle: isInvalid ? FontStyle.italic : FontStyle.normal,
                  color: _getTextColor(context),
                ),
              ),
            if (value == null)
              _buildCandidates(context, gameState),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidates(BuildContext context, GameState gameState) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    
    if (gameState.currentPuzzle == null) return const SizedBox.shrink();
    
    final candidates = _getCandidates(gameState.currentPuzzle!.currentGrid, cellRow, cellCol);
    
    if (showSingles && candidates.length == 1) {
      return Text(
        candidates.first.toString(),
        style: TextStyle(
          fontSize: 12,
          color: currentTheme.defaultCellTextColor.withOpacity(0.7),
        ),
      );
    }
    
    if (showPairs && candidates.length == 2) {
      return Text(
        candidates.join(' '),
        style: TextStyle(
          fontSize: 12,
          color: currentTheme.defaultCellTextColor.withOpacity(0.7),
        ),
      );
    }
    
    if (showTriples && candidates.length == 3) {
      return Text(
        candidates.join(' '),
        style: TextStyle(
          fontSize: 12,
          color: currentTheme.defaultCellTextColor.withOpacity(0.7),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  List<int> _getCandidates(List<List<int>> grid, int row, int col) {
    final candidates = <int>{};
    for (int num = 1; num <= 9; num++) {
      if (_isSafe(grid, row, col, num)) {
        candidates.add(num);
      }
    }
    return candidates.toList();
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

  Color _getBackgroundColor(BuildContext context) {
    final settings = context.watch<PuzzleSettings>();
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    
    if (isSelected) {
      return currentTheme.selectedCellColor;
    }
    if (isSameNumber && settings.showSameNumberHighlighting) {
      return currentTheme.relatedCellColor;
    }
    if (isHighlighted && settings.showRowSquareHighlighting) {
      return currentTheme.rowSquareHighlightColor;
    }
    return currentTheme.defaultCellBackgroundColor;
  }

  Color _getTextColor(BuildContext context) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    
    if (isInvalid) {
      return currentTheme.mistakeTextColor;
    }
    if (solutionValue != null && value == null) {
      return currentTheme.debugSolutionCellTextColor;
    }
    return currentTheme.defaultCellTextColor;
  }
} 