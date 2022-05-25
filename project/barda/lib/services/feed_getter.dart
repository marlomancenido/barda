import 'dart:convert';
import 'package:barda/models/user.dart';

import '../models/post.dart';
import 'auth.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> getPosts(int? limit, String? next, String? previous) async {
  // Retrieve Token and Generate User
  final token = await Auth.getToken(), username = await Auth.getUsername();

  User user = User(username);

  // Query
  // final query = {'limit': limit, 'next': next, 'previous': previous};

  List<Post> posts = [];
  List<String> friendsUN = await getFriends();

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
    var is_authuser = false;

    if (p['username'] == user) {
      is_authuser = true;
    }

    var post = Post(
        id: p['id'],
        text: p['text'],
        username: p['username'],
        public: p['public'],
        is_authuser: is_authuser,
        date: date,
        updated: p['updated']);

    // If public/friend/self, add to feed
    if (p['public'] ||
        friendsUN.contains(p['username']) ||
        p['username'] == username) {
      posts.add(post);
    }
  }

  return posts;
}
