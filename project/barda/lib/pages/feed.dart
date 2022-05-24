import 'dart:convert';

import 'package:barda/services/feed_getter.dart';
import 'package:barda/widgets/post_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../services/auth.dart';
import 'package:http/http.dart' as http;

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late Future<List<Post>> _posts;

  Future<List<Post>> getPosts() async {
    // Retrieve Token and Username
    final token = await Auth.getToken(), username = await Auth.getUsername();

    List<Post> posts = [];
    List<String> friends = await getFriends();

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

      // If public/friend/self, add to feed
      if (p['public'] ||
          friends.contains(p['username']) ||
          p['username'] == username) {
        posts.add(post);
      }
    }

    return posts;
  }

  @override
  void initState() {
    super.initState();
    _posts = getPosts();
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
                    padding: EdgeInsets.only(left: 30, right: 30),
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

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Text('Feed'),
    //     generatepost(context, posts[0]),
    //     ElevatedButton(
    //         onPressed: () async {
    //           getPosts(null, '', '');
    //         },
    //         child: Text('Press Me'))
    //   ],
    // );
  }
}
