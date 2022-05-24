import 'package:barda/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/post.dart';

Future<List<String>> getFriendsUN() async {
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

Future<List<Post>> getUserPosts() async {
  // Retrieve Token
  final token = await Auth.getToken();

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

    // TO DO:
    // If username matches user's username
    // if (p['username']== <users_username>){
    //  posts.add(post)
    // }

  }

  return posts;
}

Future<int> userFollowers() async {
  var friends = await getFriendsUN();
  return friends.length;
}
