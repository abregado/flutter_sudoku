import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../models/puzzle_settings.dart';
import '../../providers/theme_provider.dart';

class NumberInputRow extends StatelessWidget {
  final int? previewGreyedNumber;
  final VoidCallback? onNumberSelected;

  const NumberInputRow({
    super.key,
    this.previewGreyedNumber,
    this.onNumberSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final buttonSize = width / 5; // 5 buttons per row
        
        return SizedBox(
          height: buttonSize * 2, // Two rows
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(5, (index) => _buildNumberButton(context, index + 1, buttonSize)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(4, (index) => _buildNumberButton(context, index + 6, buttonSize)),
                  _buildClearButton(context, buttonSize),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNumberButton(BuildContext context, int number, double size) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    final gameState = context.watch<GameState>();
    final isDisabled = _isNumberDisabled(gameState, number);
    
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: previewGreyedNumber != null || isDisabled
            ? null
            : () {
                gameState.makeMove(number);
                onNumberSelected?.call();
              },
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isDisabled
                ? currentTheme.greyedNumberInputBackgroundColor
                : currentTheme.inputNumberInputBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDisabled
                  ? currentTheme.greyedNumberInputBorderColor
                  : currentTheme.inputNumberInputBorderColor,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: size * 0.4,
                color: isDisabled
                    ? currentTheme.greyedNumberInputTextColor
                    : currentTheme.inputNumberInputTextColor,
              ),
            ),
          ),
        ),
      ),
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
    if (gameState.currentPuzzle == null) return false;
    
    // Count how many times this number appears in the grid
    int count = 0;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (gameState.currentPuzzle!.currentGrid[i][j] == number) {
          count++;
        }
      }
    }
    
    // If we already have 9 of this number, disable it
    return count >= 9;
  }

  int _getNumberCount(BuildContext context, int number) {
    final gameState = context.watch<GameState>();
    if (gameState.currentPuzzle == null) return 0;
    
    int count = 0;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (gameState.currentPuzzle!.currentGrid[i][j] == number) {
          count++;
        }
      }
    }
    return count;
  }
} 