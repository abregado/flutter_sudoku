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
import '../../utils/puzzle_name_generator.dart';
import '../../models/theme_model.dart';

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

    // Group puzzles by status
    final unplayedPuzzles = puzzles.where((p) => !p.isCompleted && p.timeSpent == Duration.zero).toList();
    final inProgressPuzzles = puzzles.where((p) => !p.isCompleted && p.timeSpent > Duration.zero).toList();
    final completedPuzzles = puzzles.where((p) => p.isCompleted).toList()
      ..sort((a, b) {
        // First sort by mistakes
        if (a.mistakes != b.mistakes) {
          return a.mistakes.compareTo(b.mistakes);
        }
        // Then sort by time
        return a.timeSpent.compareTo(b.timeSpent);
      });

    // Find the fastest mistake-free puzzle
    final fastestPerfectPuzzle = completedPuzzles
        .where((p) => p.mistakes == 0)
        .isNotEmpty
        ? completedPuzzles
            .where((p) => p.mistakes == 0)
            .reduce((a, b) => a.timeSpent < b.timeSpent ? a : b)
        : null;

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
            child: ListView(
              children: [
                if (unplayedPuzzles.isNotEmpty) ...[
                  _buildSectionHeader('Unplayed Puzzles', currentTheme),
                  ...unplayedPuzzles.map((puzzle) => _buildPuzzleCard(puzzle, currentTheme, fastestPerfectPuzzle)),
                ],
                if (inProgressPuzzles.isNotEmpty) ...[
                  _buildSectionHeader('In Progress', currentTheme),
                  ...inProgressPuzzles.map((puzzle) => _buildPuzzleCard(puzzle, currentTheme, fastestPerfectPuzzle)),
                ],
                if (completedPuzzles.isNotEmpty) ...[
                  _buildSectionHeader('Completed', currentTheme),
                  ...completedPuzzles.map((puzzle) => _buildPuzzleCard(puzzle, currentTheme, fastestPerfectPuzzle)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, SudokuTheme currentTheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: currentTheme.uiTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPuzzleCard(PuzzleEntry puzzle, SudokuTheme currentTheme, PuzzleEntry? fastestPerfectPuzzle) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: puzzle.isCompleted
            ? puzzle.mistakes == 0
                ? puzzle == fastestPerfectPuzzle
                    ? const Icon(Icons.timer, color: Colors.amber, size: 32)
                    : const Icon(Icons.star, color: Colors.amber, size: 32)
                : const Icon(Icons.emoji_events, color: Colors.amber, size: 32)
            : PuzzleThumbnail(
                initialGrid: puzzle.initialGrid,
                currentGrid: puzzle.currentGrid,
                size: 36.0,
                initialCellColor: currentTheme.uiTextColor,
                currentCellColor: Colors.blue,
              ),
        title: Text(
          PuzzleNameGenerator.generateName(puzzle.id),
          style: TextStyle(
            color: currentTheme.uiTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Generated: ${puzzle.generatedAt.toString().split('.')[0]}',
              style: TextStyle(
                color: currentTheme.uiTextColor.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            if (puzzle.timeSpent > Duration.zero || puzzle.mistakes > 0) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  if (puzzle.timeSpent > Duration.zero)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: currentTheme.uiTextColor.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${puzzle.timeSpent.inMinutes}:${(puzzle.timeSpent.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: currentTheme.uiTextColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (puzzle.mistakes > 0)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 14,
                            color: currentTheme.uiTextColor.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${puzzle.mistakes} mistakes',
                            style: TextStyle(
                              color: currentTheme.uiTextColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await context.read<PuzzleLibraryProvider>().resetPuzzle(puzzle.id);
              },
              color: currentTheme.iconButtonColor,
              tooltip: 'Reset puzzle',
            ),
            if (!puzzle.isCompleted)
              IconButton(
                icon: puzzle.isActive
                    ? const Icon(Icons.play_arrow, color: Colors.green)
                    : const Icon(Icons.arrow_forward),
                onPressed: () async {
                  await context.read<PuzzleLibraryProvider>().setActivePuzzle(puzzle.id);
                  if (mounted) {
                    final gameState = context.read<GameState>();
                    final activePuzzle = context.read<PuzzleLibraryProvider>().activePuzzle;
                    if (activePuzzle != null) {
                      gameState.loadPuzzle(activePuzzle);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                      );
                    }
                  }
                },
                color: currentTheme.iconButtonColor,
                tooltip: puzzle.isActive ? 'Currently playing' : 'Play puzzle',
              ),
          ],
        ),
      ),
    );
  }
} 