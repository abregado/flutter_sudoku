import 'package:flutter/material.dart';

class PuzzleThumbnail extends StatelessWidget {
  final List<List<int>> grid;
  final double size;
  final Color cellColor;

  const PuzzleThumbnail({
    super.key,
    required this.grid,
    this.size = 36.0,
    this.cellColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PuzzleThumbnailPainter(
          grid: grid,
          cellColor: cellColor,
        ),
      ),
    );
  }
}

class _PuzzleThumbnailPainter extends CustomPainter {
  final List<List<int>> grid;
  final Color cellColor;

  _PuzzleThumbnailPainter({
    required this.grid,
    required this.cellColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 9;
    final paint = Paint()
      ..color = cellColor
      ..style = PaintingStyle.fill;

    // Draw filled cells
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] != 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * cellSize,
              row * cellSize,
              cellSize,
              cellSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 