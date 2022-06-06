// Post Class
// Making this a class makes it easier to get necessary info from a post to generate its page

class Post {
  String id, text, username;
  bool public, is_authuser;
  DateTime date;
  int updated;

  Post(
      {required this.id,
      required this.text,
      required this.username,
      required this.public,
      required this.is_authuser,
      required this.date,
      required this.updated});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        text: json['text'],
        username: json['username'],
        public: json['public'],
        is_authuser: json['is_authuser'],
        date: json['date'],
        updated: json['updated']);
  }
}
