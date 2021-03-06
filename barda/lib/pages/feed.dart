import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barda/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/auth.dart';
import '../widgets/post_container.dart';

// FEED PAGE
// This contains the posts for display. This also handles generation of posts
// and the pagination display for the posts. Currently, this has a limit of 5 posts
// per getPosts() call.

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _Feed();
}

class _Feed extends State<Feed> {
  final controller = ScrollController();
  bool hasMore =
      true; // Used to tell user if there are more posts or if they reached the end
  List<Post> posts = [];
  var lastid = '';

  // Get Posts
  // Retrieves posts from the server
  Future getPosts() async {
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

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);

      if (jsonData['data'].length > 0) {
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
          }
          if (mounted) {
            setState(() {
              lastid = p['id'];
            });
          }
        }

        if (mounted) {
          setState(() {
            posts.addAll(temp_posts);
            // If there are only few posts that the user is able to see, fetch more
            // There must be a minimum of 5 posts.
            if (posts.length < limit) {
              getPosts();
            }
          });
        }
      } else {
        if (mounted) {
          setState(() {
            hasMore = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          hasMore = false;
        });
      }
    }
  }

  // Gets called when user refreshes the feed (pulls from top)
  Future refreshFeed() async {
    if (mounted) {
      setState(() {
        hasMore = true;
        posts.clear();
        getPosts();
        lastid = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
    controller.addListener(() {
      // If end is reached, get more posts!
      if (controller.position.maxScrollExtent == controller.offset) {
        getPosts();
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
    return Scaffold(
        key: Key('feed_page'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 20),
                  child: Text(
                    'Feed',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ),
            Expanded(
                child: Scrollbar(
                    key: const Key('feed_ctrl'),
                    controller: controller,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(25),
                              topLeft: Radius.circular(25))),
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: RefreshIndicator(
                            onRefresh: refreshFeed,
                            child: ListView.builder(
                                controller: controller,
                                itemCount: posts.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < posts.length) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child:
                                          // Post rendering is done with generate post (widgets)
                                          generatepost(context, posts[index]),
                                    );
                                  } else {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 20),
                                        child: hasMore
                                            ? CupertinoActivityIndicator(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              )
                                            : const Align(
                                                alignment: Alignment.center,
                                                child: Text("No more posts",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                              ));
                                  }
                                }),
                          )),
                    )))
          ],
        ));
  }
}
