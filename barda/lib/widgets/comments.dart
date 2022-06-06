import 'dart:convert';
import 'package:barda/extensions/string_extension.dart';
import 'package:barda/models/comment.dart';
import 'package:barda/widgets/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../pages/person.dart';
import '../services/auth.dart';

// COMMENTS WIDGET
// Generates the comments for a specific post. Also handles deletion of comments.

class Comments extends StatefulWidget {
  final post_id;
  const Comments(this.post_id);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final controller = ScrollController();
  bool gotEverything = false;
  List<Comment> comments = [];
  var lastId = '';

  // Get Comments
  // Gets all comments for a specific post.
  // Sorts every comment according to date.
  // Returns response for success/error handling.
  Future getComments(String post_id) async {
    final token = await Auth.getToken(), username = await Auth.getUsername();

    final uri = Uri.https('cmsc-23-2022-bfv6gozoca-as.a.run.app',
        '/api/comment/$post_id', {'next': lastId});
    final res = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);

      for (var c in jsonData['data']) {
        var date = DateTime.fromMillisecondsSinceEpoch(c['date']);
        c['date'] = date;
        var is_authuser = false;

        if (c['username'] == username) {
          is_authuser = true;
        }
        var comment = Comment.fromJson(c);
        comment.is_authuser = is_authuser;
        setState(() {
          comments.add(comment);
          lastId = comment.id;
        });
      }
      setState(() {
        gotEverything = true;
      });
    }
    comments.sort(
      (a, b) {
        return a.date.compareTo(b.date);
      },
    );

    return res;
  }

  // Delete Comment
  // Deletes a comment if comment is auth user's comment.
  // Returns response for success/error handling.
  Future deleteComment(String post_id, String comment_id) async {
    // Get AuthToken
    var token = await Auth.getToken();

    final res = await http.delete(
        Uri.parse(
            'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/comment/$post_id/$comment_id'),
        headers: <String, String>{'Authorization': 'Bearer $token'});

    var jsonData = jsonDecode(res.body);
    return jsonData;
  }

  @override
  void initState() {
    super.initState();
    getComments(widget.post_id);
  }

  // Refresh Feed
  // Refreshes all comments.
  // Called when pulled
  Future refreshFeed() async {
    setState(() {
      comments.clear();
      getComments(widget.post_id);
      gotEverything = false;
      lastId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scrollbar(
            controller: controller,
            child: RefreshIndicator(
                onRefresh: refreshFeed,
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 0),
                    controller: controller,
                    itemCount: comments.length + 1,
                    itemBuilder: (context, index) {
                      if (index < comments.length) {
                        final date = DateFormat.yMMMMd('en_US')
                                .format(comments[index].date),
                            time = DateFormat.jm().format(comments[index].date);
                        return Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("@" + comments[index].username,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            comments[index].is_authuser
                                                ? IconButton(
                                                    key: Key('del_comment'),
                                                    onPressed: () async {
                                                      var res =
                                                          await deleteComment(
                                                              comments[index]
                                                                  .post_id,
                                                              comments[index]
                                                                  .id);
                                                      if (!res['success']) {
                                                        showError(
                                                            context,
                                                            res['statusCode'],
                                                            res['message']
                                                                .toString()
                                                                .toCapitalized());
                                                      }
                                                      if (mounted) {
                                                        setState(() {
                                                          refreshFeed();
                                                        });
                                                      }
                                                      // delete then refresh page
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 15,
                                                      color: Colors.red,
                                                    ))
                                                : Container(height: 40)
                                          ],
                                        )),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Person(
                                                comments[index].username)));
                                  },
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              comments[index].text,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            )),
                                        const Divider(),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '$time • $date',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                        )
                                      ],
                                    )),
                                const Divider(color: Colors.grey, height: 30),
                              ],
                            ));
                      } else {
                        return Align(
                          alignment: Alignment.center,
                          child: gotEverything
                              ? const Text("No more comments",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300))
                              : CupertinoActivityIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                        );
                      }
                    }))));
  }
}
