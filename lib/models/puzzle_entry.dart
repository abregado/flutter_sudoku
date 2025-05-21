import 'package:flutter/foundation.dart';

class PuzzleEntry {
  final String id;
  final List<List<int>> initialGrid;
  final List<List<int>> solution;
  List<List<int>> currentGrid;
  final DateTime generatedAt;
  DateTime? completedAt;
  Duration timeSpent;
  int mistakes;
  bool isCompleted;
  bool isActive;

  PuzzleEntry({
    required this.id,
    required this.initialGrid,
    required this.solution,
    required this.currentGrid,
    required this.generatedAt,
    this.completedAt,
    this.timeSpent = Duration.zero,
    this.mistakes = 0,
    this.isCompleted = false,
    this.isActive = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initialGrid': initialGrid,
      'solution': solution,
      'currentGrid': currentGrid,
      'generatedAt': generatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'timeSpent': timeSpent.inSeconds,
      'mistakes': mistakes,
      'isCompleted': isCompleted,
      'isActive': isActive,
    };
  }

  factory PuzzleEntry.fromJson(Map<String, dynamic> json) {
    return PuzzleEntry(
      id: json['id'] as String,
      initialGrid: (json['initialGrid'] as List)
          .map((row) => (row as List).map((cell) => cell as int).toList())
          .toList(),
      solution: (json['solution'] as List)
          .map((row) => (row as List).map((cell) => cell as int).toList())
          .toList(),
      currentGrid: (json['currentGrid'] as List)
          .map((row) => (row as List).map((cell) => cell as int).toList())
          .toList(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      timeSpent: Duration(milliseconds: json['timeSpent'] as int),
      mistakes: json['mistakes'] as int,
      isCompleted: json['isCompleted'] as bool,
      isActive: json['isActive'] as bool,
    );
  }

  PuzzleEntry copyWith({
    String? id,
    List<List<int>>? initialGrid,
    List<List<int>>? solution,
    List<List<int>>? currentGrid,
    DateTime? generatedAt,
    DateTime? completedAt,
    Duration? timeSpent,
    int? mistakes,
    bool? isCompleted,
    bool? isActive,
  }) {
    return PuzzleEntry(
      id: id ?? this.id,
      initialGrid: initialGrid ?? this.initialGrid,
      solution: solution ?? this.solution,
      currentGrid: currentGrid ?? this.currentGrid,
      generatedAt: generatedAt ?? this.generatedAt,
      completedAt: completedAt ?? this.completedAt,
      timeSpent: timeSpent ?? this.timeSpent,
      mistakes: mistakes ?? this.mistakes,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
    );
  }
} 