import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/puzzle_entry.dart';

class PuzzleLibraryProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final String _storageKey = 'puzzle_library';
  List<PuzzleEntry> _puzzles = [];
  PuzzleEntry? _activePuzzle;

  PuzzleLibraryProvider(this._prefs) {
    _loadPuzzles();
  }

  List<PuzzleEntry> get puzzles => List.unmodifiable(_puzzles);
  PuzzleEntry? get activePuzzle => _activePuzzle;

  void _loadPuzzles() {
    final String? jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _puzzles = jsonList.map((json) => PuzzleEntry.fromJson(json)).toList();
      _activePuzzle = _puzzles.firstWhere((p) => p.isActive, orElse: () => _puzzles.first);
      notifyListeners();
    }
  }

  Future<void> _savePuzzles() async {
    final jsonList = _puzzles.map((puzzle) => puzzle.toJson()).toList();
    await _prefs.setString(_storageKey, json.encode(jsonList));
  }

  Future<void> addPuzzle(List<List<int>> initialGrid, List<List<int>> solution) async {
    final puzzle = PuzzleEntry(
      id: const Uuid().v4(),
      initialGrid: initialGrid,
      solution: solution,
      currentGrid: List.from(initialGrid),
      generatedAt: DateTime.now(),
    );

    // Deactivate current active puzzle if exists
    if (_activePuzzle != null) {
      final index = _puzzles.indexWhere((p) => p.id == _activePuzzle!.id);
      if (index != -1) {
        _puzzles[index] = _puzzles[index].copyWith(isActive: false);
      }
    }

    _puzzles.add(puzzle);
    _activePuzzle = puzzle;
    await _savePuzzles();
    notifyListeners();
  }

  Future<void> updatePuzzle(PuzzleEntry puzzle) async {
    final index = _puzzles.indexWhere((p) => p.id == puzzle.id);
    if (index != -1) {
      _puzzles[index] = puzzle;
      if (puzzle.isActive) {
        _activePuzzle = puzzle;
      }
      await _savePuzzles();
      notifyListeners();
    }
  }

  Future<void> setActivePuzzle(String id) async {
    // First, deactivate the current active puzzle if any
    if (_activePuzzle != null) {
      final index = _puzzles.indexWhere((p) => p.id == _activePuzzle!.id);
      if (index != -1) {
        _puzzles[index] = _puzzles[index].copyWith(isActive: false);
      }
    }

    // Find and activate the new puzzle
    final index = _puzzles.indexWhere((p) => p.id == id);
    if (index != -1) {
      final puzzle = _puzzles[index].copyWith(isActive: true);
      _puzzles[index] = puzzle;
      _activePuzzle = puzzle;
      await _savePuzzles();
      notifyListeners();
    }
  }

  List<PuzzleEntry> getSortedPuzzles() {
    final sorted = List<PuzzleEntry>.from(_puzzles);
    sorted.sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
    return sorted;
  }

  Future<void> resetPuzzle(String id) async {
    final index = _puzzles.indexWhere((p) => p.id == id);
    if (index != -1) {
      final puzzle = _puzzles[index];
      final resetPuzzle = puzzle.copyWith(
        currentGrid: List.from(puzzle.initialGrid),
        timeSpent: Duration.zero,
        completedAt: null,
        isCompleted: false,
        mistakes: 0,
      );
      _puzzles[index] = resetPuzzle;
      if (resetPuzzle.isActive) {
        _activePuzzle = resetPuzzle;
      }
      await _savePuzzles();
      notifyListeners();
    }
  }
} 