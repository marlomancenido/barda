import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import 'dart:convert';

import '../services/auth.dart';
import '../widgets/post_container.dart';

class UserPosts extends StatefulWidget {
  const UserPosts({Key? key}) : super(key: key);

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  late Future<List<Post>> _posts;

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
      var is_authuser = false;

      if (p['username'] == username) {
        is_authuser = true;
      }
      var date = DateTime.fromMillisecondsSinceEpoch(p['date']);
      var post = Post(
          id: p['id'],
          text: p['text'],
          username: p['username'],
          public: p['public'],
          is_authuser: is_authuser,
          date: date,
          updated: p['updated']);

      if (p['username'] == username) {
        posts.add(post);
      }
    }

    return posts;
  }

  @override
  void initState() {
    super.initState();
    _posts = getUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _posts,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return CupertinoActivityIndicator(color: Colors.white);
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: generatepost(context, snapshot.data[index]),
                          );
                        }),
                  ))
                ],
              );
            }
          }),
    );
  }
}
