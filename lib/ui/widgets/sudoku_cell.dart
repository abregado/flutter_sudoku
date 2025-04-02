import 'package:flutter/material.dart';

class SudokuCell extends StatelessWidget {
  final int? value;
  final bool isInitial;
  final bool isSelected;
  final bool isHighlighted;
  final bool isInvalid;
  final VoidCallback onTap;
  final bool isRightBorder;
  final bool isBottomBorder;

  const SudokuCell({
    super.key,
    required this.value,
    required this.isInitial,
    required this.isSelected,
    required this.isHighlighted,
    required this.isInvalid,
    required this.onTap,
    this.isRightBorder = false,
    this.isBottomBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getCellColor(context),
          border: Border(
            right: BorderSide(
              width: isRightBorder ? 2.0 : 1.0,
              color: Theme.of(context).dividerColor,
            ),
            bottom: BorderSide(
              width: isBottomBorder ? 2.0 : 1.0,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        child: Center(
          child: value != null
              ? Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: isInitial ? FontWeight.bold : FontWeight.normal,
                    color: isInvalid
                        ? Colors.red
                        : isInitial
                            ? Colors.black87
                            : Colors.blue,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Color _getCellColor(BuildContext context) {
    if (isSelected) {
      return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7);
    } else if (isHighlighted) {
      return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3);
    } else {
      return Colors.transparent;
    }
  }
} 