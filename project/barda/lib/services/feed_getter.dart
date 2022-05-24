import 'dart:convert';

import 'package:barda/services/user.dart';

import '../models/post.dart';
import 'auth.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> getPosts(int? limit, String? next, String? previous) async {
  // Retrieve Token
  final token = await Auth.getToken();

  // Query
  // final query = {'limit': limit, 'next': next, 'previous': previous};

  List<Post> posts = [];
  List<String> friendsUN = await getFriendsUN();

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

    // If public, add to feed
    if (p['public']) {
      posts.add(post);
    } else if (friendsUN.contains(p['username'])) {
      posts.add(post);
    }
    // To Do:
    // Else if self, add to feed

  }

  return posts;

  // print(posts);
}
