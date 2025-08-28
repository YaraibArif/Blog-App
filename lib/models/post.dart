class Post {
  final int? id;
  final String title;
  final String body;
  final List<String> tags;
  final int views;
  final Map<String, dynamic> reactions;
  final String? category;
  final DateTime? createdAt;

  Post({
    this.id,
    required this.title,
    required this.body,
    required this.tags,
    this.views = 0,
    Map<String, dynamic>? reactions,
    this.category,
    this.createdAt,
  }) : reactions = reactions ?? {"likes": 0, "dislikes": 0};

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'] ?? "",
      body: json['body'] ?? "",
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      views: json['views'] ?? 0,
      reactions: Map<String, dynamic>.from(json['reactions'] ?? {"likes": 0, "dislikes": 0}),
      category: json['category'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'title': title,
      'body': body,
      'tags': tags,
      'views': views,
      'reactions': reactions,
    };

    if (category != null) {
      map['category'] = category!;
    }
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }
}
