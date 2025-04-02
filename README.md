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
- [ ] Advanced features
  - [ ] Move validation
  - [ ] Timer
  - [ ] Difficulty levels

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/flutter_sudoku.git
```

2. Navigate to the project directory:
```bash
cd flutter_sudoku
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

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
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 