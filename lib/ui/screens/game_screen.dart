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
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: () => context.read<GameState>().toggleTimer(),
          ),
        ],
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Stack(
            children: [
              Column(
                children: [
                  if (gameState.showTimer)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        gameState.formattedTime,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mistakes: ${gameState.mistakes}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (gameState.showTimer)
                          Text(
                            gameState.formattedTime,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SudokuGrid(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: NumberInputRow(),
                  ),
                ],
              ),
              if (gameState.isComplete)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 100,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Congratulations!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () {
                            gameState.resetTimer();
                            _startNewGame();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('New Puzzle'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
} 