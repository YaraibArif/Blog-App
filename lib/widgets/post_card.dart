import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String user;
  final String time;
  final String content;
  final int likes;
  final int comments;
  final int shares;
  final String avatarUrl;

  const PostCard({
    super.key,
    required this.user,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.avatarUrl,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isSaved = false; //

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  User info
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: widget.avatarUrl.contains("assets/")
                      ? AssetImage(widget.avatarUrl) as ImageProvider
                      : NetworkImage(widget.avatarUrl),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            //  Post content
            Text(
              widget.content,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),

            const SizedBox(height: 12),

            //  Stats Row with Save button
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Text(widget.likes.toString(),
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(width: 16),

                const Icon(Icons.comment, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(widget.comments.toString(),
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(width: 16),

                const Icon(Icons.share, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(widget.shares.toString(),
                    style: const TextStyle(color: Colors.white70)),

                const Spacer(),

                // Save button
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.blue : Colors.grey,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      isSaved = !isSaved;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
