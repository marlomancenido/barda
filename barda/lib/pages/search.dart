import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/user.dart';
import '../services/auth.dart';
import '../widgets/post_container.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final controller = ScrollController();
  bool hasMore = true;
  List<Post> posts = [];
  var lastid = '';

  Future getPostsw() async {
    // Retrieve Token and Username
    final token = await Auth.getToken(), username = await Auth.getUsername();
    List<String> friends = await getFriends();
    var limit = 5;
    List<Post> temp_posts = [];

    final uri = Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app', '/api/post',
        {'limit': limit.toString(), 'next': lastid});
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

      if (p['username'] == username) {
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
          friends.contains(p['username']) ||
          p['username'] == username) {
        temp_posts.add(post);
        lastid = p['id'];
      }
    }

    setState(() {
      posts.addAll(temp_posts);

      if (temp_posts.length < limit) {
        hasMore = false;
      }
    });
  }

  Future refreshFeed() async {
    print('refresh');
    setState(() {
      hasMore = true;
      posts.clear();
    });
    getPostsw();
  }

  @override
  void initState() {
    super.initState();
    getPostsw();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        getPostsw();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
            onRefresh: refreshFeed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
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
                              padding: EdgeInsets.only(top: 10),
                              child: hasMore
                                  ? CupertinoActivityIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    )
                                  : Text("No more posts"));
                        }
                      }),
                ))
              ],
            )));
  }
}
