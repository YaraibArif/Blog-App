import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';
import '../widgets/search_screen_ui.dart';
import 'posts_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All Stories";

  final List<String> categories = [
    "All Stories",
    "Technology",
    "Business",
    "Health",
    "Science",
    "Sports"
  ];

  final List<String> sources = [
    "TechDaily",
    "BusinessWeek",
    "HealthNews",
    "ScienceToday",
    "SportsCentral"
  ];
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<PostsProvider>(context, listen: false);
      provider.initSearch(); // yeh dono kaam karega: fetch + searchResults fill
    });
  }



  void _onSearch(String query) {
    final provider = Provider.of<PostsProvider>(context, listen: false);
    provider.searchPosts(query);
  }

  void _onCategorySelected(String category) {
    final provider = Provider.of<PostsProvider>(context, listen: false);
    setState(() => _selectedCategory = category);

    if (category == "All Stories") {
      if (_searchController.text.isEmpty) {
        provider.initSearch();
      } else {
        provider.searchPosts(_searchController.text); // agar search text hai to uske hisaab se
      }
    } else {
      provider.searchByCategory(category); // category filter
    }
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PostsScreen()),
            );
          },
        ),
        title: const Text(
          "Search",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search stories...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1C1C1C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🏷 Category Filter
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => _onCategorySelected(cat),
                  selectedColor: Colors.blue,
                  backgroundColor: const Color(0xFF2A2A2A),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          //Search Results
          Expanded(
            child: provider.searchResults.isEmpty
                ? const Center(
                child: Text("No results found",
                    style: TextStyle(color: Colors.white54)))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.searchResults.length,
              itemBuilder: (context, index) {
                final post = provider.searchResults[index];
                final views = post['views'] ?? 0;
                final createdAt = DateTime.now()
                    .subtract(Duration(minutes: index * 15));

                return SearchResultCard(
                  post: post,
                  source: sources[index % sources.length],
                  createdAt: createdAt,
                  views: views,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
