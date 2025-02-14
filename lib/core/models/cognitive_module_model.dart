import 'package:flutter/foundation.dart';

class CognitiveModuleModel extends ChangeNotifier {
  List<BrainGame> brainGames = [];
  List<MemoryExercise> memoryExercises = [];
  List<DailyPuzzle> dailyPuzzles = [];
  List<ReadingMaterial> readingMaterials = [];
  List<MusicTherapy> musicTherapySessions = [];

  Future<void> updateGameProgress(String gameId, int score) async {
    try {
      final gameIndex = brainGames.indexWhere((game) => game.id == gameId);
      if (gameIndex != -1) {
        final game = brainGames[gameIndex];
        if (score > game.highScore) {
          brainGames[gameIndex] = game.copyWith(highScore: score);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error updating game progress: $e');
      rethrow;
    }
  }
}

class BrainGame {
  final String id;
  final String name;
  final String description;
  final String category;
  final int difficultyLevel;
  final int highScore;
  final List<String> skills;
  final Map<String, dynamic> gameConfig;

  BrainGame({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficultyLevel,
    required this.highScore,
    required this.skills,
    required this.gameConfig,
  });

  BrainGame copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? difficultyLevel,
    int? highScore,
    List<String>? skills,
    Map<String, dynamic>? gameConfig,
  }) {
    return BrainGame(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      highScore: highScore ?? this.highScore,
      skills: skills ?? this.skills,
      gameConfig: gameConfig ?? this.gameConfig,
    );
  }
}

class MemoryExercise {
  final String id;
  final String title;
  final String description;
  final ExerciseType type;
  final int difficultyLevel;
  final Duration timeLimit;
  final Map<String, dynamic> exerciseData;

  MemoryExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficultyLevel,
    required this.timeLimit,
    required this.exerciseData,
  });
}

enum ExerciseType { visualMemory, verbalMemory, workingMemory, patternRecognition }

class DailyPuzzle {
  final String id;
  final String title;
  final String description;
  final PuzzleType type;
  final DateTime date;
  final int difficultyLevel;
  final Map<String, dynamic> puzzleData;
  final String solution;

  DailyPuzzle({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    required this.difficultyLevel,
    required this.puzzleData,
    required this.solution,
  });
}

enum PuzzleType { sudoku, crossword, wordSearch, riddle, logicPuzzle }

class ReadingMaterial {
  final String id;
  final String title;
  final String author;
  final String content;
  final List<String> categories;
  final int readingLevel;
  final Duration estimatedReadTime;
  final List<ComprehensionQuestion> questions;

  ReadingMaterial({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.categories,
    required this.readingLevel,
    required this.estimatedReadTime,
    required this.questions,
  });
}

class ComprehensionQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  ComprehensionQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}

class MusicTherapy {
  final String id;
  final String title;
  final String description;
  final List<String> genres;
  final Duration duration;
  final String audioUrl;
  final Map<String, dynamic> therapyGoals;
  final List<String> recommendations;

  MusicTherapy({
    required this.id,
    required this.title,
    required this.description,
    required this.genres,
    required this.duration,
    required this.audioUrl,
    required this.therapyGoals,
    required this.recommendations,
  });
}
