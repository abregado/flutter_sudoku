import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/puzzle_settings.dart';
import '../../providers/theme_provider.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
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
          ],
        ),
      ),
    );
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