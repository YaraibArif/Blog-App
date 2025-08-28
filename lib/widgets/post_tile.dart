import 'package:flutter/material.dart';
import '../screens/post_edit_screen.dart';
import '../screens/posts_screen.dart';

class PostTile extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback? onDelete;

  const PostTile({
    super.key,
    required this.post,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              post: post,
              onDelete: onDelete ?? () {},
            ),
          ),
        );
      },
      child: Card(
        color: const Color(0xFF1C1C1C),
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      post['title'] ?? "",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: onDelete,
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Body text
              Text(
                post['body'] ?? "",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 10),

              // Tags
              if (post['tags'] != null)
                Wrap(
                  spacing: 6,
                  children: (post['tags'] as List)
                      .map((tag) => Chip(
                    label: Text(tag.toString()),
                    backgroundColor: Colors.grey[800],
                    labelStyle:
                    const TextStyle(color: Colors.white),
                  ))
                      .toList(),
                ),

              const SizedBox(height: 10),

              // Likes, Dislikes, Views
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.thumb_up,
                          color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        post['reactions']?['likes'].toString() ?? "0",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 120),
                      const Icon(Icons.thumb_down,
                          color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        post['reactions']?['dislikes'].toString() ?? "0",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye_outlined,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        formatNumber(post['views'] ?? 0),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
