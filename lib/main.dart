import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/game_state.dart';
import 'models/puzzle_settings.dart';
import 'models/theme_model.dart';
import 'providers/theme_provider.dart';
import 'providers/puzzle_library_provider.dart';
import 'ui/screens/game_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/theme_screen.dart';
import 'ui/screens/library_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({
    super.key,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider(create: (_) => PuzzleSettings(prefs)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PuzzleLibraryProvider(prefs)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final currentTheme = themeProvider.currentTheme;
          return MaterialApp(
            title: 'Flutter Sudoku',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: currentTheme.selectedCellColor),
              scaffoldBackgroundColor: currentTheme.backgroundColor,
              useMaterial3: true,
            ),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    final libraryProvider = context.watch<PuzzleLibraryProvider>();
    
    // If there's no active puzzle, show the library screen
    if (libraryProvider.activePuzzle == null) {
      return const LibraryScreen();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        backgroundColor: currentTheme.topBarColor,
        foregroundColor: currentTheme.topBarFontColor,
        iconTheme: IconThemeData(color: currentTheme.iconButtonColor),
      ),
      body: GameScreen(gameState: GameState()),
      drawer: NavigationDrawer(
        onDestinationSelected: (int index) {
          Navigator.pop(context); // Close the drawer
          
          switch (index) {
            case 0:
              // Already on GameScreen, do nothing
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LibraryScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemeScreen()),
              );
              break;
          }
        },
        children: const [
          NavigationDrawerDestination(
            icon: Icon(Icons.grid_4x4),
            label: Text('Game'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.library_books),
            label: Text('Library'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.palette),
            label: Text('Themes'),
          ),
        ],
      ),
    );
  }
}
