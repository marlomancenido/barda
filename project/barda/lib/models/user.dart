import 'package:barda/models/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth.dart';

class User {
  // String username, firstName, lastName;
  // User(this.username, this.firstName, this.lastName);
  String username;
  User(this.username);
}

Future<List<Post>> getUserPosts() async {
  // Retrieve Token and Username
  final token = await Auth.getToken(), username = await Auth.getUsername();

  List<Post> posts = [];
  final uri = Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/post');
  final res = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  var jsonData = jsonDecode(res.body);

  for (var p in jsonData['data']) {
    var date = DateTime.fromMillisecondsSinceEpoch(p['date']);
    var post = Post(
        id: p['id'],
        text: p['text'],
        username: p['username'],
        public: p['public'],
        date: date,
        updated: p['updated']);

    if (p['username'] == username) {
      posts.add(post);
    }
  }

  return posts;
}

Future<List<String>> getFriends() async {
  List<String> friends = [];

  // Retrieve Token
  final token = await Auth.getToken();

  final uri = Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/user');
  final res = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );

  var jsonData = jsonDecode(res.body);

  for (var u in jsonData['data']) {
    friends.add(u['username']);
  }

  return friends;
}

Future<int> getNoFollowers() async {
  var friends = await getFriends();
  return friends.length;
}

Future getAuthUserData() async {
  final username = await Auth.getUsername();
  final friends = await getFriends();
  final count = friends.length;

  return {'username': username, 'followers_count': count};
}

Future isFriends(String username) async {
  final friends = await getFriends();
  return friends.contains(username);
}
