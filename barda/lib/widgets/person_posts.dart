import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import 'dart:convert';
import '../models/user.dart';
import '../services/auth.dart';
import 'post_container.dart';

// PERSON POSTS
// Generates the posts of a person/user in their profile. Gets all their posts and displays it.
// Also handles function for post retrieval for said user.

class PersonPosts extends StatefulWidget {
  final String username;
  // Username for getting their posts. Included in constructor.

  const PersonPosts(this.username);

  @override
  State<PersonPosts> createState() => _PersonPostsState();
}

class _PersonPostsState extends State<PersonPosts> {
  var lastId = '';
  List<Post> posts = [];
  final controller = ScrollController();
  bool hasMore = true;

  // Get user Posts
  // Modified version of get posts in feed. Gets all user's posts
  Future getUserPosts() async {
    // Retrieve Token and Username
    final token = await Auth.getToken(),
        is_Friends = await isFriends(widget.username);
    final uri = Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/post',
        {'username': widget.username});
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

        var date = DateTime.fromMillisecondsSinceEpoch(p['date']);
        var post = Post(
            id: p['id'],
            text: p['text'],
            username: p['username'],
            public: p['public'],
            is_authuser: is_authuser,
            date: date,
            updated: p['updated']);

        if (p['public']) {
          setState(() {
            posts.add(post);
          });
        } else if (is_Friends) {
          setState(() {
            posts.add(post);
          });
        }

        setState(() {
          lastId = post.id;
        });
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

  // Refresh Feed
  // Handles refreshing posts. Called when pulled.
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
        controller: controller,
        child: RefreshIndicator(
            onRefresh: refreshFeed,
            child: ListView.builder(
                controller: controller,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: generatepost(context, posts[index]),
                    );
                  } else {
                    return Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: hasMore
                            ? CupertinoActivityIndicator(
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : const Align(
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
