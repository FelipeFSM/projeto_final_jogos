class Post {
  final String title;
  final String body;
  final int userId;
  final int? id;

  Post({
    required this.title,
    required this.body,
    required this.userId,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
      if (id != null) 'id': id,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }
}