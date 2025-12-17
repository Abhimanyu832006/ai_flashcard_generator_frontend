import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';

class FlashcardProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Flashcard> _flashcards = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Flashcard> get flashcards => _flashcards;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _error = message;
    notifyListeners();
  }

  void setFlashcards(List<Flashcard> cards) {
    _flashcards = cards;
    notifyListeners();
  }

  void clear() {
    _error = null;
    _flashcards = [];
    notifyListeners();
  }
}
