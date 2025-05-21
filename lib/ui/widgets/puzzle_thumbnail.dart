import 'package:flutter/material.dart';

class PuzzleThumbnail extends StatelessWidget {
  final List<List<int>> initialGrid;
  final List<List<int>> currentGrid;
  final double size;
  final Color initialCellColor;
  final Color currentCellColor;

  const PuzzleThumbnail({
    super.key,
    required this.initialGrid,
    required this.currentGrid,
    this.size = 36.0,
    this.initialCellColor = Colors.black,
    this.currentCellColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PuzzleThumbnailPainter(
          initialGrid: initialGrid,
          currentGrid: currentGrid,
          initialCellColor: initialCellColor,
          currentCellColor: currentCellColor,
        ),
      ),
    );
  }
}

class _PuzzleThumbnailPainter extends CustomPainter {
  final List<List<int>> initialGrid;
  final List<List<int>> currentGrid;
  final Color initialCellColor;
  final Color currentCellColor;

  _PuzzleThumbnailPainter({
    required this.initialGrid,
    required this.currentGrid,
    required this.initialCellColor,
    required this.currentCellColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 9;

    // Draw initial cells in black
    final initialPaint = Paint()
      ..color = initialCellColor
      ..style = PaintingStyle.fill;

    // Draw current cells in blue
    final currentPaint = Paint()
      ..color = currentCellColor
      ..style = PaintingStyle.fill;

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (initialGrid[row][col] != 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * cellSize,
              row * cellSize,
              cellSize,
              cellSize,
            ),
            initialPaint,
          );
        } else if (currentGrid[row][col] != 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * cellSize,
              row * cellSize,
              cellSize,
              cellSize,
            ),
            currentPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 