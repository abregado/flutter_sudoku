import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/game_state.dart';
import 'models/puzzle_settings.dart';
import 'models/theme_model.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/game_screen.dart';

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
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final currentTheme = themeProvider.currentTheme;
          return MaterialApp(
            title: 'Flutter Sudoku',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: currentTheme.primaryColor),
              scaffoldBackgroundColor: currentTheme.backgroundColor,
              useMaterial3: true,
            ),
            home: const GameScreen(),
          );
        },
      ),
    );
  }
}
