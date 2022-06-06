import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import 'dart:convert';

import '../services/auth.dart';
import 'post_container.dart';

class UserPosts extends StatefulWidget {
  const UserPosts({Key? key}) : super(key: key);

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  var lastId = '';
  List<Post> posts = [];
  final controller = ScrollController();
  bool hasMore = true;

  Future getUserPosts() async {
    // Retrieve Token and Username
    final token = await Auth.getToken(), username = await Auth.getUsername();
    final uri = Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/post',
        {'username': username});
    final res = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    var jsonData = jsonDecode(res.body);

    if (res.statusCode == 200) {
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
          setState(() {
            posts.add(post);
            lastId = post.id;
          });
        }
      }
      setState(() {
        hasMore = false;
      });
    }

    return jsonData;
  }

  @override
  void initState() {
    super.initState();
    getUserPosts();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future refreshFeed() async {
    setState(() {
      hasMore = true;
      posts.clear();
      getUserPosts();
      lastId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        thumbVisibility: true,
        controller: controller,
        child: RefreshIndicator(
            onRefresh: refreshFeed,
            child: ListView.builder(
                controller: controller,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: generatepost(context, posts[index]),
                    );
                  } else {
                    return Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: hasMore
                            ? CupertinoActivityIndicator(
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Text("No more posts",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300)),
                              ));
                  }
                })));
  }
}
