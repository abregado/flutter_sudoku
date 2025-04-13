# Flutter Sudoku

A simple offline Sudoku game app built with Flutter.

## Features

- Minimalistic design
- Offline gameplay
- Backtracking algorithm for board generation
- Auto-save puzzle state
- Basic game mechanics
- Undo functionality
- Puzzle time recorded
- Mistake counter
- Settings for difficulty and display options
- Cross-platform support (Android, Windows, Linux)

## Feature Roadmap
- Share puzzles via QR codes

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/               # Data models
│   └── game_state.dart   # Game state management
│   └── puzzle_settings.dart   # Settings
│   └── sudoku_generator.dart   # Basic puzzle generation 
├── ui/                   # User interface
│   ├── screens/          # App screens
│   │   └── game_screen.dart
│   │   └── settings_screen.dart
│   ├── widgets/          # Reusable widgets
│   │   ├── sudoku_grid.dart
│   │   ├── sudoku_cell.dart
│   │   └── number_input_row.dart
│   └── themes/           # App themes
└── utils/               # Utility functions
    └── puzzle_generator.dart
```


## License

This project is licensed under the MIT License - see the LICENSE file for details. 