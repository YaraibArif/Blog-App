import 'package:blog_app/screens/posts_screen.dart';
import 'package:blog_app/screens/quote_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quotes_provider.dart';
import '../widgets/quote_card.dart';
import 'favourite_screen.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<QuotesProvider>(context, listen: false).fetchQuotes());
  }

  @override
  Widget build(BuildContext context) {
    final quotesProvider = Provider.of<QuotesProvider>(context);

    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.pink
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PostsScreen()),
            );
          }
        ),
        title: Row(
          children: const [
            Icon(Icons.format_quote, color: Colors.blue, size: 25),
            SizedBox(width: 8),
            Text("Quotes", style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          // Search Button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2A2A2A), // dark grey circle
            ),
         child:  IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () async {
              final provider =
              Provider.of<QuotesProvider>(context, listen: false);

              final query = await showSearch<String>(
                context: context,
                delegate: QuoteSearchDelegate(provider),
              );

              if (query != null) {
                provider.setSearchQuery(query);
              }
            },
          ),
          ),

          // Favorites Button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2A2A2A), // dark grey circle
            ),
          child:IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
          ),
          ),
        ],
      ),

      body: Builder(
        builder: (context) {
          if (quotesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (quotesProvider.error != null) {
            return Center(
              child: Text(
                "Error: ${quotesProvider.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (quotesProvider.quotes.isEmpty) {
            return const Center(
              child: Text(
                "No quotes found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: quotesProvider.quotes.length,
            itemBuilder: (context, index) {
              final q = quotesProvider.quotes[index];
              return QuoteCard(
                quote: q,
                color: colors[index % colors.length],
              );
            },
          );
        },
      ),
    );
  }
}
