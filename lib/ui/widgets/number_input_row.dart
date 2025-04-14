import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../models/puzzle_settings.dart';
import '../../providers/theme_provider.dart';

class NumberInputRow extends StatelessWidget {
  final int? previewGreyedNumber;

  const NumberInputRow({
    super.key,
    this.previewGreyedNumber,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final buttonSize = width / 10; // 9 numbers + 1 clear button
        
        return SizedBox(
          height: buttonSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(9, (index) => _buildNumberButton(context, index + 1, buttonSize)),
              _buildClearButton(context, buttonSize),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNumberButton(BuildContext context, int number, double size) {
    return Consumer3<GameState, PuzzleSettings, ThemeProvider>(
      builder: (context, gameState, settings, themeProvider, child) {
        final currentTheme = themeProvider.currentTheme;
        final isDisabled = previewGreyedNumber != null && previewGreyedNumber == number? true : _isNumberDisabled(gameState, number);
        final shouldGrey = settings.showFinishedNumbers && isDisabled;
        
        return SizedBox(
          width: size,
          height: size,
          child: GestureDetector(
            onTap: previewGreyedNumber != null ? null : (isDisabled ? null : () => gameState.makeMove(number)),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: shouldGrey
                        ? currentTheme.greyedNumberInputBackgroundColor 
                        : currentTheme.inputNumberInputBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: shouldGrey
                          ? currentTheme.greyedNumberInputBorderColor 
                          : currentTheme.inputNumberInputBorderColor,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    fontSize: size * 0.5,
                    color: shouldGrey
                            ? currentTheme.greyedNumberInputTextColor 
                            : currentTheme.inputNumberInputTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildClearButton(BuildContext context, double size) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: previewGreyedNumber != null ? null : () => context.read<GameState>().makeMove(null),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: currentTheme.clearNumberInputButtonBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: currentTheme.clearNumberInputButtonBorderColor,
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.clear,
            size: size * 0.5,
            color: currentTheme.clearNumberInputButtonTextColor,
          ),
        ),
      ),
    );
  }
  
  bool _isNumberDisabled(GameState gameState, int number) {
    // Count how many times this number appears in the grid
    int count = 0;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (gameState.grid[i][j] == number) {
          count++;
        }
      }
    }
    
    // If we already have 9 of this number, disable it
    return count >= 9;
  }
} 