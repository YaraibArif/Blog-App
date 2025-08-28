import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onDelete;

  const PostDetailScreen({
    super.key,
    required this.post,
    required this.onDelete,
  });

  String formatNumber(int number) {
    return NumberFormat.compact().format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Daily Stories",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📊 Likes, Dislikes, Views, Share
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Icon(Icons.favorite, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(formatNumber(post['reactions']?['likes'] ?? 0),
                        style: const TextStyle(color: Colors.white)),
                  ]),
                  Row(children: [
                    const Icon(Icons.heart_broken, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(formatNumber(post['reactions']?['dislikes'] ?? 0),
                        style: const TextStyle(color: Colors.white)),
                  ]),
                  Row(children: [
                    const Icon(Icons.remove_red_eye_outlined, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(formatNumber(post['views'] ?? 0),
                        style: const TextStyle(color: Colors.white)),
                  ]),
                  const Icon(Icons.share, color: Colors.white),
                ],
              ),
              const SizedBox(height: 20),

              // 📝 Title
              Text(
                post['title'] ?? "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // 📄 Body
              Text(
                post['body'] ?? "",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 20),

              // 🗑️ Delete Button
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    "Delete Post",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
