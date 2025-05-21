import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../models/game_state.dart';
import '../../models/puzzle_settings.dart';
import '../../providers/theme_provider.dart';
import '../../utils/puzzle_generator.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_input_row.dart';
import 'settings_screen.dart';
import 'theme_screen.dart';
import '../../providers/puzzle_library_provider.dart';
import 'library_screen.dart';

class GameScreen extends StatefulWidget {
  final GameState gameState;
  
  const GameScreen({
    super.key,
    required this.gameState,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late GameState _gameState;
  bool _showSolution = false;
  bool _showPairs = false;
  bool _showSingles = false;
  bool _showTriples = false;
  
  @override
  void initState() {
    super.initState();
    _gameState = widget.gameState;
    WidgetsBinding.instance.addObserver(this);
    // Enable wakelock to keep screen on during gameplay
    WakelockPlus.enable();
    // Start the timer when the screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActivePuzzle();
    });
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Disable wakelock when leaving the game screen
    WakelockPlus.disable();
    // Stop the timer when the screen is disposed
    _gameState.stopTimer();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _gameState.stopTimer();
      // Disable wakelock when app goes to background
      WakelockPlus.disable();
    } else if (state == AppLifecycleState.resumed) {
      _gameState.startTimer();
      // Re-enable wakelock when app comes to foreground
      WakelockPlus.enable();
    }
  }
  
  void _loadActivePuzzle() {
    final libraryProvider = context.read<PuzzleLibraryProvider>();
    final activePuzzle = libraryProvider.activePuzzle;
    if (activePuzzle != null) {
      final oldPuzzle = _gameState.loadPuzzle(activePuzzle);
      
      // If there was an old puzzle, update it in the library
      if (oldPuzzle != null) {
        libraryProvider.updatePuzzle(oldPuzzle);
      }
      
      // Force a rebuild
      setState(() {});
    } else {
      // If no active puzzle, go to library
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LibraryScreen()),
        );
      });
    }
  }
  
  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
  
  void _openThemes() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ThemeScreen(),
      ),
    );
  }
  
  void _checkPuzzleCompletion() {
    if (_gameState.isComplete) {
      final libraryProvider = context.read<PuzzleLibraryProvider>();
      final activePuzzle = libraryProvider.activePuzzle;
      if (activePuzzle != null) {
        libraryProvider.updatePuzzle(
          activePuzzle.copyWith(
            isCompleted: true,
            completedAt: DateTime.now(),
            timeSpent: activePuzzle.timeSpent,
            mistakes: activePuzzle.mistakes,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    final gameState = context.watch<GameState>();
    final libraryProvider = context.watch<PuzzleLibraryProvider>();
    
    // Check if we have no current puzzle
    if (gameState.currentPuzzle == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LibraryScreen()),
        );
      });
      return const SizedBox.shrink();
    }

    // Check for puzzle completion in a post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPuzzleCompletion();
    });

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
        body: Consumer<GameState>(
          builder: (context, gameState, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<PuzzleSettings>(
                            builder: (context, settings, child) {
                              if (!settings.showMistakes) return const SizedBox.shrink();
                              return Text(
                                'Mistakes: ${gameState.currentPuzzle?.mistakes ?? 0}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: currentTheme.uiTextColor,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          Consumer<PuzzleSettings>(
                            builder: (context, settings, child) {
                              if (!settings.showTimer) return const SizedBox.shrink();
                              return Text(
                                gameState.formattedTime,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: currentTheme.uiTextColor,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (const bool.fromEnvironment('dart.vm.product') == false)
                            IconButton(
                              icon: Icon(
                                _showSolution ? Icons.visibility_off : Icons.visibility,
                                color: _showSolution ? Colors.grey : currentTheme.iconButtonColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showSolution = !_showSolution;
                                });
                              },
                              tooltip: 'Toggle solution visibility',
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SudokuGrid(
                          showSolution: _showSolution,
                          showPairs: _showPairs,
                          showSingles: _showSingles,
                          showTriples: _showTriples,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (const bool.fromEnvironment('dart.vm.product') == false)
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showSingles = !_showSingles;
                                });
                              },
                              icon: Icon(_showSingles ? Icons.visibility_off : Icons.visibility),
                              label: Text('Singles'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentTheme.inputNumberInputBackgroundColor,
                                foregroundColor: currentTheme.inputNumberInputTextColor,
                              ),
                            ),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showPairs = !_showPairs;
                              });
                            },
                            icon: Icon(_showPairs ? Icons.visibility_off : Icons.visibility),
                            label: Text('Pairs'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentTheme.inputNumberInputBackgroundColor,
                              foregroundColor: currentTheme.inputNumberInputTextColor,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showTriples = !_showTriples;
                              });
                            },
                            icon: Icon(_showTriples ? Icons.visibility_off : Icons.visibility),
                            label: Text('Triples'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentTheme.inputNumberInputBackgroundColor,
                              foregroundColor: currentTheme.inputNumberInputTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0 + bottomPadding,
                      ),
                      child: NumberInputRow(
                        onNumberSelected: () {                        
                        },
                      ),
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
                          const SizedBox(height: 8),
                          Text(
                            'Time: ${gameState.formatDuration(gameState.currentPuzzle?.timeSpent ?? Duration.zero)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Mistakes: ${gameState.currentPuzzle?.mistakes ?? 0}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LibraryScreen()),
                              );
                            },
                            icon: const Icon(Icons.library_books),
                            label: const Text('Back to Library'),
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
      ),
    );
  }
} 