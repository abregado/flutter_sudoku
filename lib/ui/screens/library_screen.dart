import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/puzzle_library_provider.dart';
import '../../models/puzzle_entry.dart';
import '../../utils/puzzle_generator.dart';
import '../../models/puzzle_settings.dart';
import '../../providers/theme_provider.dart';
import '../../models/game_state.dart';
import '../../main.dart';
import 'game_screen.dart';
import '../widgets/puzzle_thumbnail.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final PuzzleGenerator _generator = BacktrackingGenerator();
  bool _isGenerating = false;
  double _generationProgress = 0.0;

  Future<void> _generateNewPuzzle() async {
    setState(() {
      _isGenerating = true;
      _generationProgress = 0.0;
    });

    try {
      final settings = context.read<PuzzleSettings>();
      final (grid, solution) = await _generator.generatePuzzleAsync(
        settings,
        (progress) {
          setState(() {
            _generationProgress = progress;
          });
        },
      );

      // Convert nullable int grid to non-nullable
      final nonNullableGrid = grid.map((row) => 
        row.map((cell) => cell ?? 0).toList()
      ).toList();

      await context.read<PuzzleLibraryProvider>().addPuzzle(nonNullableGrid, solution);
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    final libraryProvider = context.watch<PuzzleLibraryProvider>();
    final puzzles = libraryProvider.getSortedPuzzles();

    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Puzzle Library'),
        backgroundColor: currentTheme.topBarColor,
        foregroundColor: currentTheme.topBarFontColor,
        iconTheme: IconThemeData(color: currentTheme.iconButtonColor),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generateNewPuzzle,
                  icon: _isGenerating
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            value: _generationProgress,
                            strokeWidth: 2,
                            color: currentTheme.iconButtonColor,
                          ),
                        )
                      : const Icon(Icons.add),
                  label: Text(_isGenerating ? 'Generating...' : 'New Puzzle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentTheme.inputNumberInputBackgroundColor,
                    foregroundColor: currentTheme.inputNumberInputTextColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: puzzles.length,
              itemBuilder: (context, index) {
                final puzzle = puzzles[index];
                return ListTile(
                  leading: puzzle.isCompleted
                      ? const Icon(Icons.emoji_events, color: Colors.amber)
                      : PuzzleThumbnail(
                          grid: puzzle.initialGrid,
                          size: 36.0,
                          cellColor: currentTheme.uiTextColor,
                        ),
                  title: Text(
                    'Puzzle ${puzzle.id.substring(0, 8)}',
                    style: TextStyle(color: currentTheme.uiTextColor),
                  ),
                  subtitle: Text(
                    'Generated: ${puzzle.generatedAt.toString().split('.')[0]}\n'
                    'Time: ${puzzle.timeSpent.inMinutes}:${(puzzle.timeSpent.inSeconds % 60).toString().padLeft(2, '0')}\n'
                    'Mistakes: ${puzzle.mistakes}',
                    style: TextStyle(color: currentTheme.uiTextColor.withOpacity(0.7)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await libraryProvider.resetPuzzle(puzzle.id);
                        },
                        color: currentTheme.iconButtonColor,
                      ),
                      if (!puzzle.isCompleted)
                        IconButton(
                          icon: puzzle.isActive
                              ? const Icon(Icons.play_arrow, color: Colors.green)
                              : const Icon(Icons.arrow_forward),
                          onPressed: () async {
                            await libraryProvider.setActivePuzzle(puzzle.id);
                            if (mounted) {
                              // Get the GameState from the provider
                              final gameState = context.read<GameState>();
                              final activePuzzle = libraryProvider.activePuzzle;
                              if (activePuzzle != null) {
                                gameState.loadPuzzle(activePuzzle);
                                // Navigate back to MainScreen which will show GameScreen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MainScreen()),
                                );
                              }
                            }
                          },
                          color: currentTheme.iconButtonColor,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 