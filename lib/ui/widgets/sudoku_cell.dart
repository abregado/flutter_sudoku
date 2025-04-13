import 'package:flutter/material.dart';

class SudokuCell extends StatelessWidget {
  final int? value;
  final int? solutionValue;
  final bool isInitial;
  final bool isSelected;
  final bool isHighlighted;
  final bool isInvalid;
  final bool showTopBorder;
  final bool showBottomBorder;
  final bool showLeftBorder;
  final bool showRightBorder;
  final VoidCallback onTap;

  const SudokuCell({
    super.key,
    required this.value,
    this.solutionValue,
    required this.isInitial,
    required this.isSelected,
    required this.isHighlighted,
    required this.isInvalid,
    required this.showTopBorder,
    required this.showBottomBorder,
    required this.showLeftBorder,
    required this.showRightBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: showTopBorder ? 1.0 : 0.0,
            ),
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: showBottomBorder ? 1.0 : 0.0,
            ),
            left: BorderSide(
              color: Theme.of(context).dividerColor,
              width: showLeftBorder ? 1.0 : 0.0,
            ),
            right: BorderSide(
              color: Theme.of(context).dividerColor,
              width: showRightBorder ? 1.0 : 0.0,
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
                  fontSize: 20,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
            if (value != null)
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: isInitial ? FontWeight.bold : FontWeight.normal,
                  color: _getTextColor(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (isSelected) {
      return Theme.of(context).colorScheme.primaryContainer;
    }
    if (isHighlighted) {
      return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3);
    }
    return Colors.transparent;
  }

  Color _getTextColor(BuildContext context) {
    if (isInvalid) {
      return Theme.of(context).colorScheme.error;
    }
    if (isInitial) {
      return Theme.of(context).colorScheme.onSurface;
    }
    return Theme.of(context).colorScheme.onSurface;
  }
} 