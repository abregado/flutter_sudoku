import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/puzzle_settings.dart';
import '../../models/game_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<PuzzleSettings>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              // Display Options
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Display Options',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('Show Timer'),
                value: settings.showTimer,
                onChanged: (value) {
                  settings.toggleTimer();
                  // Also update the GameState timer visibility
                  context.read<GameState>().toggleTimer();
                },
              ),
              SwitchListTile(
                title: const Text('Show Mistakes'),
                value: settings.showMistakes,
                onChanged: (value) {
                  settings.toggleMistakes();
                },
              ),
              
              const Divider(),
              
              // Hints Section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Hints',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('Row/Square Highlighting'),
                subtitle: const Text('Highlight related rows, columns, and squares'),
                value: settings.showRowSquareHighlighting,
                onChanged: (value) {
                  settings.toggleRowSquareHighlighting();
                },
              ),
              SwitchListTile(
                title: const Text('Same Number Highlighting'),
                subtitle: const Text('Highlight cells with the same number'),
                value: settings.showSameNumberHighlighting,
                onChanged: (value) {
                  settings.toggleSameNumberHighlighting();
                },
              ),
              SwitchListTile(
                title: const Text('Finished Numbers'),
                subtitle: const Text('Grey out numbers that have been fully placed'),
                value: settings.showFinishedNumbers,
                onChanged: (value) {
                  settings.toggleFinishedNumbers();
                },
              ),
            ],
          );
        },
      ),
    );
  }
} 