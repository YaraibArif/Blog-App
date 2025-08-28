class User {
  final int id;
  final String name;
  final String username;
  final String profilePic;
  final int posts;
  final int likes;
  final int views;
  final List<String> userPosts;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.profilePic,
    required this.posts,
    required this.likes,
    required this.views,
    required this.userPosts,
  });

  // To parse data from Api
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: "${json['firstName'] ?? ''} ${json['lastName'] ?? ''}".trim(),
      username: json['username'] ?? "unknown",
      profilePic: json['image'] ??
          "https://via.placeholder.com/150",
      posts: json['posts'] is int ? json['posts'] : 0,
      likes: json['likes'] is int ? json['likes'] : 0,
      views: json['views'] is int ? json['views'] : 0,
      userPosts: (json['userPosts'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  // Local Demo Data
  factory User.demo() {
    return User(
      id: 1,
      name: "Emily Jhonson",
      username: "Emily_J_design",
      profilePic: "assets/emily.png",
      posts: 127,
      likes: 2400,
      views: 15200,
      userPosts: [
        "Just finished working on this amazing UI design project. The dark theme really brings out the modern aesthetic! 🎨",
        "Mobile design patterns are evolving so fast. Love how minimalism is making a comeback in 2024! ✨",
        "Working late tonight on a new app concept. Sometimes the best ideas come when the world is quiet 🌙",
        "Collaboration makes everything better. Grateful for my amazing design team! 🙌",
      ],
    );
  }

  // copyWith method (for updating fields safely)
  User copyWith({
    int? id,
    String? name,
    String? username,
    String? profilePic,
    int? posts,
    int? likes,
    int? views,
    List<String>? userPosts,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      posts: posts ?? this.posts,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      userPosts: userPosts ?? this.userPosts,
    );
  }
}

//Extension for converting back to JSON
extension UserJson on User {
  Map<String, dynamic> toJson() {
    final nameParts = name.split(' ');
    return {
      'id': id,
      'firstName': nameParts.isNotEmpty ? nameParts[0] : '',
      'lastName': nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      'username': username,
      'image': profilePic,
      'posts': posts,
      'likes': likes,
      'views': views,
      'userPosts': userPosts,
    };
  }
}
