import 'package:flutter/material.dart';
import '../providers/quotes_provider.dart';
import '../widgets/quote_card.dart';

class QuoteSearchDelegate extends SearchDelegate<String> {
  final QuotesProvider provider;

  QuoteSearchDelegate(this.provider);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D0D0D), // dark appbar
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => close(context, ""),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = provider.quotes.where((q) =>
    q.quote.toLowerCase().contains(query.toLowerCase()) ||
        q.author.toLowerCase().contains(query.toLowerCase())).toList();

    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.pink
    ];

    if (results.isEmpty) {
      return const Center(
        child: Text(
          "No results found",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return QuoteCard(
          quote: results[index],
          color: colors[index % colors.length],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        color: const Color(0xFF0D0D0D),
        child: const Center(
          child: Text(
            "Type to search quotes...",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final suggestions = provider.quotes.where((q) =>
    q.quote.toLowerCase().contains(query.toLowerCase()) ||
        q.author.toLowerCase().contains(query.toLowerCase())).toList();

    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.pink
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return QuoteCard(
          quote: suggestions[index],
          color: colors[index % colors.length],
        );
      },
    );
  }
}
