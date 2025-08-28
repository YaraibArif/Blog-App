import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/quotes_service.dart';

class QuotesProvider extends ChangeNotifier {
  final QuotesService _service = QuotesService();

  List<Quote> quotes = [];
  List<Quote> favorites = [];
  bool isLoading = false;
  String? error;
  int _skip = 0;
  final int _limit = 20;
  bool hasMore = true;

  // Search filter
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<Quote> get filteredQuotes {
    if (_searchQuery.isEmpty) return quotes;
    return quotes
        .where((q) =>
    q.quote.toLowerCase().contains(_searchQuery) ||
        q.author.toLowerCase().contains(_searchQuery))
        .toList();
  }

  // Favorites
  void toggleFavorite(Quote quote) {
    if (favorites.contains(quote)) {
      favorites.remove(quote);
    } else {
      favorites.add(quote);
    }
    notifyListeners();
  }

  bool isFavorite(Quote quote) {
    return favorites.contains(quote);
  }

  Future<void> fetchQuotes({bool loadMore = false}) async {
    if (isLoading) return;

    if (!loadMore) {
      quotes = [];
      _skip = 0;
      hasMore = true;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final newQuotes = await _service.fetchQuotes(limit: _limit, skip: _skip);
      if (newQuotes.isEmpty) {
        hasMore = false;
      } else {
        quotes.addAll(newQuotes);
        _skip += _limit;
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
