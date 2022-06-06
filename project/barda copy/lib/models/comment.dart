class Comment {
  String id, text, username, post_id;
  bool is_authuser;
  DateTime date;

  Comment(
      {required this.id,
      required this.text,
      required this.post_id,
      required this.username,
      required this.is_authuser,
      required this.date});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      username: json['username'],
      post_id: json['postId'],
      is_authuser: json['is_authuser'],
      date: json['date'],
    );
  }
}
