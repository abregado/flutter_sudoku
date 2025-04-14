import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_model.dart';
import '../../providers/theme_provider.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_input_row.dart';

class ThemeScreen extends StatelessWidget {
  // Static preview data to show both initial and player numbers
  static const List<List<bool>> previewInitialCells = [
    [true,  false, true,  false, false, true,  false, true,  false],
    [false, true,  false, true,  false, false, true,  false, true],
    [true,  false, true,  false, true,  false, false, true,  false],
    [false, true,  false, false, false, true,  true,  false, false],
    [true,  false, false, true,  true,  true,  false, false, true],
    [false, false, true,  true,  false, false, false, true,  false],
    [false, true,  false, false, true,  false, true,  false, true],
    [true,  false, true,  false, false, true,  false, true,  false],
    [false, true,  false, true,  false, false, true,  false, true],
  ];

  const ThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final currentTheme = themeProvider.currentTheme;
        return Container(
          decoration: currentTheme.backgroundImage != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(currentTheme.backgroundImage!),
                    fit: BoxFit.cover,
                  ),
                )
              : BoxDecoration(color: currentTheme.backgroundColor),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Themes'),
              backgroundColor: currentTheme.topBarColor,
              foregroundColor: currentTheme.topBarFontColor,
            ),
            body: Column(
              children: [
                const SizedBox(height: 20),
                // Preview grid with static numbers and highlighting
                const SudokuGrid(
                  isPreview: true,
                  showSolution: false,
                  previewInitialCells: previewInitialCells,
                ),
                const SizedBox(height: 20),
                // Number input row for preview
                const NumberInputRow(previewGreyedNumber: 5),
                const SizedBox(height: 40),
                // Theme carousel
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: SudokuTheme.allThemes.length,
                    itemBuilder: (context, index) {
                      final theme = SudokuTheme.allThemes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: ThemeButton(
                          theme: theme,
                          isSelected: theme.name == currentTheme.name,
                          onTap: () => themeProvider.setTheme(theme),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ThemeButton extends StatelessWidget {
  final SudokuTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeButton({
    Key? key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.selectedCellColor : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorSwatch(color: theme.selectedCellColor),
                ColorSwatch(color: theme.relatedCellColor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorSwatch(color: theme.rowSquareHighlightColor),
                ColorSwatch(color: theme.defaultCellBackgroundColor),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              theme.name,
              style: TextStyle(
                  fontSize: 12,
                  color: currentTheme.uiTextColor
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ColorSwatch extends StatelessWidget {
  final Color color;

  const ColorSwatch({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
    );
  }
} 