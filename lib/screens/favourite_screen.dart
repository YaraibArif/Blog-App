import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quotes_provider.dart';
import '../widgets/quote_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuotesProvider>(context);
    final colors = [Colors.blue, Colors.purple, Colors.green, Colors.orange, Colors.pink];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
            "Favorites",
            style: TextStyle(
                color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: provider.favorites.isEmpty
          ? const Center(child: Text("No favorites yet", style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: provider.favorites.length,
        itemBuilder: (context, index) {
          final q = provider.favorites[index];
          return QuoteCard(
            quote: q,
            color: colors[index % colors.length],
          );
        },
      ),
    );
  }
}
