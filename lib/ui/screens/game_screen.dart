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

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  final PuzzleGenerator _generator = BacktrackingGenerator();
  bool _showSolution = false;
  bool _showPairs = false;
  bool _showSingles = false;
  bool _showTriples = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Enable wakelock to keep screen on during gameplay
    WakelockPlus.enable();
    // Start the timer when the screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameState>().startTimer();
    });
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Disable wakelock when leaving the game screen
    WakelockPlus.disable();
    // Stop the timer when the screen is disposed
    context.read<GameState>().stopTimer();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final gameState = context.read<GameState>();
    if (state == AppLifecycleState.paused) {
      gameState.stopTimer();
      // Disable wakelock when app goes to background
      WakelockPlus.disable();
    } else if (state == AppLifecycleState.resumed) {
      gameState.startTimer();
      // Re-enable wakelock when app comes to foreground
      WakelockPlus.enable();
    }
  }
  
  void _startNewGame() {
    final settings = context.read<PuzzleSettings>();
    final gameState = context.read<GameState>();
    
    final (grid, solution) = _generator.generatePuzzle(settings);
    gameState.startNewGameWithPuzzle(grid, solution);
    gameState.resetTimer();
    gameState.startTimer();
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
  
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    
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
          title: const Text('Sudoku'),
          backgroundColor: currentTheme.topBarColor,
          foregroundColor: currentTheme.topBarFontColor,
          iconTheme: IconThemeData(color: currentTheme.iconButtonColor),
          actions: [
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
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: _openThemes,
              tooltip: 'Themes',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _openSettings,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _startNewGame,
            ),
          ],
        ),
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
                                'Mistakes: ${gameState.mistakes}',
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
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showSingles = !_showSingles;
                                if (_showSingles) {
                                  _showPairs = false;
                                  _showTriples = false;
                                }
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
                                if (_showPairs) {
                                  _showSingles = false;
                                  _showTriples = false;
                                }
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
                                if (_showTriples) {
                                  _showSingles = false;
                                  _showPairs = false;
                                }
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
                          if (_showPairs) {
                            setState(() {
                              _showPairs = false;
                            });
                          }
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
                            'Time: ${gameState.formatDuration(gameState.completionTime!)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Mistakes: ${gameState.completionMistakes}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
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
      ),
    );
  }
} 