# Flutter Sudoku

A simple offline Sudoku game app built with Flutter.

## Features

- [x] Minimalistic design
- [x] Offline gameplay
- [x] Backtracking algorithm for board generation
- [x] Auto-save puzzle state
- [x] Share puzzles via QR codes
- [x] Basic game mechanics
  - [x] Cell selection
  - [x] Number input
  - [x] Clear cell
  - [x] Mistake tracking
  - [x] Undo functionality
- [x] Timer with pause/resume
- [x] Mistake counter
- [x] Settings for difficulty and display options
- [x] Cross-platform support (Android, Windows, Linux)

## Testing

### Android Testing
1. Download the latest APK from the [Releases](https://github.com/yourusername/flutter_sudoku/releases) page
2. Enable "Install from Unknown Sources" in your Android settings
3. Install the APK
4. Test the app and report any issues in the [Issues](https://github.com/yourusername/flutter_sudoku/issues) section

### Windows Testing
1. Download the latest Windows build from the [Releases](https://github.com/yourusername/flutter_sudoku/releases) page
2. Extract the zip file
3. Run `flutter_sudoku.exe`
4. Test the app and report any issues in the [Issues](https://github.com/yourusername/flutter_sudoku/issues) section

### Linux Testing
1. Download the latest Linux build from the [Releases](https://github.com/yourusername/flutter_sudoku/releases) page
2. Extract the tar.gz file
3. Run `flutter_sudoku`
4. Test the app and report any issues in the [Issues](https://github.com/yourusername/flutter_sudoku/issues) section

## Development

### Prerequisites
- Flutter SDK (3.19.0 or later)
- Android Studio / VS Code
- Git

### Setup
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run` to start the app

### Building Release Versions
Release builds are automatically created when pushing to the `release` branch. You can also manually trigger a build from the Actions tab.

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/               # Data models
│   └── game_state.dart   # Game state management
├── ui/                   # User interface
│   ├── screens/          # App screens
│   │   └── game_screen.dart
│   ├── widgets/          # Reusable widgets
│   │   ├── sudoku_grid.dart
│   │   └── number_input_row.dart
│   └── themes/           # App themes
└── utils/               # Utility functions
    └── sudoku_generator.dart
```

## Development Status

### Completed
- Basic app structure
- Game state management
- Sudoku grid UI
- Number input system
- Cell selection
- Clear cell functionality
- Mistake tracking
- Undo functionality

### In Progress
- Move validation
- Puzzle generation
- UI polish

### Planned
- Hint system
- Timer
- Difficulty levels
- Statistics tracking
- QR code sharing
- Auto-save functionality

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 