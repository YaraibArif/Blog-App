import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final String source;
  final DateTime createdAt;
  final int views;

  const SearchResultCard({
    super.key,
    required this.post,
    required this.source,
    required this.createdAt,
    required this.views,
  });

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    } else {
      return DateFormat('dd MMM').format(date);
    }
  }

  String _formatViews(int views) {
    return NumberFormat.compact().format(views);
  }

  Color _tagColor(String tag) {
    switch (tag.toLowerCase()) {
      case "technology":
        return Colors.blue;
      case "business":
        return Colors.green;
      case "health":
        return Colors.red;
      case "science":
        return Colors.purple;
      case "sports":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = post['title'] ?? "No Title";
    final tag = (post['tags'] != null && post['tags'].isNotEmpty)
        ? post['tags'][0].toString()
        : "General";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://picsum.photos/100/100?random=${post['id']}",
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 80,
                width: 80,
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image, color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),

                // Source + Time
                Row(
                  children: [
                    Text(
                      source,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "• ${_timeAgo(createdAt)}",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Tag + Views
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tag with dynamic color
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _tagColor(tag),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),

                    // Views
                    Row(
                      children: [
                        const Icon(Icons.visibility,
                            size: 14, color: Colors.white54),
                        const SizedBox(width: 4),
                        Text(
                          _formatViews(views),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
