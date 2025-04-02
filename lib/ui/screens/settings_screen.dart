import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/puzzle_settings.dart';

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
              // Difficulty Section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Difficulty',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...Difficulty.values.map((difficulty) => RadioListTile<Difficulty>(
                title: Text(difficulty.name.toUpperCase()),
                value: difficulty,
                groupValue: settings.difficulty,
                onChanged: (value) {
                  if (value != null) {
                    settings.setDifficulty(value);
                  }
                },
              )),
              
              const Divider(),
              
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
                onChanged: (value) => settings.toggleTimer(),
              ),
              SwitchListTile(
                title: const Text('Show Mistakes'),
                value: settings.showMistakes,
                onChanged: (value) => settings.toggleMistakes(),
              ),
            ],
          );
        },
      ),
    );
  }
} 