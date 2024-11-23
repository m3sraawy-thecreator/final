import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void toggleFavorite(Map<String, dynamic> person) {
    final isFavorite = _favorites.any((fav) => fav['id'] == person['id']);
    if (isFavorite) {
      _favorites.removeWhere((fav) => fav['id'] == person['id']);
    } else {
      _favorites.add(person);
    }
    notifyListeners();
  }

  bool isFavorite(int id) {
    return _favorites.any((fav) => fav['id'] == id);
  }
}
