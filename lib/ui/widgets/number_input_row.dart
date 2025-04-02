import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';

class NumberInputRow extends StatelessWidget {
  const NumberInputRow({super.key});

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
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final isDisabled = _isNumberDisabled(gameState, number);
        
        return SizedBox(
          width: size,
          height: size,
          child: GestureDetector(
            onTap: isDisabled ? null : () => gameState.makeMove(number),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isDisabled ? Colors.grey[200] : Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDisabled ? Colors.grey[300]! : Colors.blue[200]!,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    fontSize: size * 0.5,
                    color: isDisabled ? Colors.grey[400] : Colors.blue[700],
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
    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        onTap: () => context.read<GameState>().makeMove(null),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.red[200]!,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.clear,
            size: size * 0.5,
            color: Colors.red[700],
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