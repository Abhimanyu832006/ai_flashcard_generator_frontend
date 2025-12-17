import 'dart:async';
import 'package:file_picker/file_picker.dart';

import '../models/flashcard_model.dart';

class ApiService {
  /// This is a MOCK implementation.
  /// Later, this will be replaced with real HTTP code.
  static Future<List<Flashcard>> generateFlashcards(
      PlatformFile file) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Fake response (what backend will eventually send)
    return [
      Flashcard(
        question: 'What is Artificial Intelligence?',
        answer:
            'Artificial Intelligence is the simulation of human intelligence in machines.',
      ),
      Flashcard(
        question: 'What is a Flashcard?',
        answer:
            'A flashcard is a learning tool used to aid memorization.',
      ),
    ];
  }
}
