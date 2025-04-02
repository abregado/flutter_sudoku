import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../../models/puzzle_settings.dart';
import '../../utils/puzzle_generator.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_input_row.dart';
import 'settings_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final PuzzleGenerator _generator = BacktrackingGenerator();
  
  void _startNewGame() {
    final settings = context.read<PuzzleSettings>();
    final gameState = context.read<GameState>();
    
    final (grid, solution) = _generator.generatePuzzle(settings);
    gameState.startNewGameWithPuzzle(grid, solution);
  }
  
  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              context.read<GameState>().undo();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mistake counter
            Consumer2<GameState, PuzzleSettings>(
              builder: (context, gameState, settings, child) {
                if (!settings.showMistakes) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Mistakes: ${gameState.mistakes}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              },
            ),
            
            // Sudoku grid
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SudokuGrid(),
              ),
            ),
            
            // Number input row
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: NumberInputRow(),
            ),
          ],
        ),
      ),
    );
  }
} 