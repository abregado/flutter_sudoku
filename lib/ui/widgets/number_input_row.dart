import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';

class NumberInputRow extends StatelessWidget {
  const NumberInputRow({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Clear button
          _buildClearButton(context, gameState),
          
          // Number buttons
          ...List.generate(9, (index) {
            final number = index + 1;
            final isDisabled = _isNumberDisabled(gameState, number);
            
            return _buildNumberButton(context, number, isDisabled, gameState);
          }),
        ],
      ),
    );
  }
  
  Widget _buildClearButton(BuildContext context, GameState gameState) {
    return GestureDetector(
      onTap: () {
        if (gameState.selectedRow != null && gameState.selectedCol != null) {
          gameState.makeMove(gameState.selectedRow!, gameState.selectedCol!, null);
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            Icons.clear,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
  
  Widget _buildNumberButton(BuildContext context, int number, bool isDisabled, GameState gameState) {
    return GestureDetector(
      onTap: isDisabled ? null : () {
        if (gameState.selectedRow != null && gameState.selectedCol != null) {
          gameState.makeMove(gameState.selectedRow!, gameState.selectedCol!, number);
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDisabled 
              ? Theme.of(context).disabledColor.withOpacity(0.2)
              : Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDisabled 
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
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